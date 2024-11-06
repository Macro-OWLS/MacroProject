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
    @Published var errorMessage: String?

    private let authService = AuthService.shared
    private let userUserCase: UserUseCaseType = UserUseCase()

    func signIn() async throws {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        let result = try await userUserCase.userSignIn(LoginDTO(email: userRegisterInput.email, password: userRegisterInput.password))
        
        let getUserSession = try await authService.getSession()
        
        DispatchQueue.main.async {
            self.isLoading = false
            switch result {
            case .success:
                self.isAuthenticated = true
                self.user = UserModel(
                    id: getUserSession.user.id.uuidString,
                    updatedAt: getUserSession.user.updatedAt,
                    email: getUserSession.user.email,
                    fullName: getUserSession.user.userMetadata["fullName"]?.stringValue,
                    avatarURL: "",
                    website: "",
                    lastSignInAt: getUserSession.user.lastSignInAt,
                    accessToken: getUserSession.accessToken,
                    refreshToken: getUserSession.refreshToken
                )
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func getUser() async throws {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        let user = try await userUserCase.getUserByEmail(email: authService.getSession().user.email ?? "")
        
        DispatchQueue.main.async {
            switch user {
                case .success(let user):
                print("USERRRR: \(user)")
                self.user = user
            case .failure:
                self.isLoading = false
            }
        }
    }
    
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
    
    func signOut() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        await authService.signOut { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
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
