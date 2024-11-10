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
    
    private let authService = SupabaseAuthService.shared
    private let firebaseAuthService = FirebaseAuthService.shared
    private let userUserCase: UserUseCaseType = UserUseCase()
    
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
        
        print("Result: \(result)")
        
        let getUserSession = firebaseAuthService.getSessionUser()
        print("User session: \(getUserSession?.uid)")
        
        DispatchQueue.main.async {
            self.isLoading = false
            switch result {
            case .success:
                self.isAuthenticated = true
                self.user = UserModel(
                    id: getUserSession?.uid ?? "",
                    updatedAt: getUserSession?.metadata.lastSignInDate,
                    email: getUserSession?.email,
                    fullName: getUserSession?.displayName,
                    avatarURL: "",
                    website: "",
                    lastSignInAt: getUserSession?.metadata.lastSignInDate,
                    accessToken: "",
                    refreshToken: getUserSession?.refreshToken
                )
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
            Task {
                do {
                    try await self?.userUserCase.userSignOut()
                    let session = self?.firebaseAuthService.getSessionUser()
                } catch {
                    print("Failed to fetch session: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                guard let self = self else { return }
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
    
    private func clearCredentials() {
        userRegisterInput.email = ""
        userRegisterInput.password = ""
        userRegisterInput.fullName = ""
    }
}
