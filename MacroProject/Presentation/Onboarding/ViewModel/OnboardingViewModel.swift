//
//  OnboardingViewModel.swift
//  MacroProject
//
//  Created by Agfi on 05/11/24.
//

import Foundation
import Combine

internal final class OnboardingViewModel: ObservableObject {
    @Published var userRegisterInput: RegisterDTO = RegisterDTO(email: "", password: "", fullName: "")
    @Published var user: UserModel = UserModel(id: "")
    @Published var streak: Int = 0
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var isUserFetched: Bool = false
    @Published var errorMessage: String?
    @Published var userInputTarget: String = ""
    @Published var userTarget: Int = 0
    @Published var lastTargetUpdateDate: Date? = nil
    @Published var cooldownTimeRemaining: Int = 0
    @Published var isDisabled: Bool = true
    @Published var showConfirmationAlert: Bool = false
    
    private let authService = SupabaseAuthService.shared
    private let firebaseAuthService = FirebaseAuthService.shared
    private let userUserCase: UserUseCaseType = UserUseCase()
    private let phraseCardUseCase: PhraseCardUseCaseType = PhraseCardUseCase()
    private let topicUseCase: TopicUseCaseType = TopicUseCase()
    private var today: Date = Calendar.current.startOfDay(for: Date())
    private var timer: AnyCancellable?
    
    func register() async throws {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        let result = try await userUserCase.userSignUp(userRegisterInput)
        
        DispatchQueue.main.async {
            switch result {
            case .success:
                self.isLoading = false
            case .failure(let error):
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func signIn() async throws {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        let result = try await userUserCase.userSignIn(LoginDTO(email: userRegisterInput.email, password: userRegisterInput.password))
        let getUserSession = try await userUserCase.getUserSession()
        DispatchQueue.main.async {
            self.isLoading = false
            switch result {
            case .success:
                self.isAuthenticated = true
                Task {
                    try await SynchronizationHelper().synchronizeRemoteToLocal()
                }
                SyncManager.markAsSynchronized()
                self.user = getUserSession ?? UserModel(id: "0")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    @MainActor
    func getUser() async {
        guard !isUserFetched else { return }
        self.isLoading = true
        
        do {
            if let user = try await userUserCase.getUserSession() {
                self.user = user
                self.userTarget = user.targetStreak ?? 99
                self.lastTargetUpdateDate = user.lastTargetUpdated ?? Date()
                self.isAuthenticated = true
            } else {
                self.isAuthenticated = false
            }
            isUserFetched = true
        } catch {
            self.isAuthenticated = false
        }
        self.isLoading = false
    }
    
    func signOut() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        firebaseAuthService.signOut { [weak self] result in
            guard let self = self else { return }
            Task {
                do {
                    try await self.phraseCardUseCase.removeAllPhrases()
                    try await self.topicUseCase.removeAllTopics()
                    SyncManager.markAsNotSynchronized()
                    try await self.userUserCase.userSignOut()
                } catch {
                    print("Failed to fetch session: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success:
                    self.isAuthenticated = false
                    self.clearCredentials()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func deleteAccount() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        do {
            let getUserSession = try await userUserCase.getUserSession()
            try await self.phraseCardUseCase.removeAllPhrases()
            try await self.topicUseCase.removeAllTopics()
            SyncManager.markAsNotSynchronized()
            try await self.userUserCase.deleteAccount(uid: getUserSession?.id ?? "")
            DispatchQueue.main.async {
                self.isAuthenticated = false
                self.isLoading = false
                self.errorMessage = nil
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func clearCredentials() {
        userRegisterInput.email = ""
        userRegisterInput.password = ""
        userRegisterInput.fullName = ""
    }
    
    func updateUserTarget() async {
//        guard canUpdateTarget() else {
//            DispatchQueue.main.async {
//                self.errorMessage = "You can only update your target once every 7 days."
//            }
//            return
//        }
        
        do {
            try await userUserCase.updateUserTarget(uid: user.id, targetStreak: Int(userInputTarget) ?? 99, lastTargetUpdated: today)
            DispatchQueue.main.async {
                self.lastTargetUpdateDate = self.today
                self.updateCooldown()
                self.userInputTarget = ""
                self.isDisabled = true
                print("\nupdate target viewmodel\n ")
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to update user target: \(error.localizedDescription)"
            }
        }
    }

    func canUpdateTarget() -> Bool {
        guard let lastUpdate = lastTargetUpdateDate else {
            return true
        }
        
        let daysSinceLastUpdate = Calendar.current.dateComponents([.day], from: lastUpdate, to: today).day ?? 0
        
        if daysSinceLastUpdate >= 7 && cooldownTimeRemaining == 0 {
            DispatchQueue.main.async {
                self.isDisabled = false
            }
            return true
        } else {
            return false
        }
    }
    
    func updateCooldown() {
        guard let lastUpdate = lastTargetUpdateDate else {
            return
        }
        
        let daysSinceLastUpdate = Calendar.current.dateComponents([.day], from: lastUpdate, to: today).day ?? 0
        
        DispatchQueue.main.async {
            self.cooldownTimeRemaining = 7 - daysSinceLastUpdate
        }
    }
}
