//
//  OnboardingViewModel.swift
//  MacroProject
//
//  Created by Agfi on 05/11/24.
//

import Foundation
import Combine

internal final class OnboardingViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var streak: Int = 0
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?

    private let authService = AuthService.shared

    func signIn() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        let result = await authService.signIn(email: email, password: password)
        
        DispatchQueue.main.async {
            self.isLoading = false
            switch result {
            case .success:
                self.isAuthenticated = true
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func register() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        let user = RegisterDTO(email: email, password: password, fullName: name)
        
        await authService.register(user: user) { [weak self] isSucceed, error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false
                if isSucceed {
                    self.isAuthenticated = true
                } else {
                    self.errorMessage = error?.localizedDescription ?? "Registration failed"
                }
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
                    self.clearCredentials() // Optional: clear email, password, etc.
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func clearCredentials() {
        email = ""
        password = ""
        name = ""
    }
}
