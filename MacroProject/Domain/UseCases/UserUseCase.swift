//
//  UserUseCase.swift
//  MacroProject
//
//  Created by Agfi on 06/11/24.
//

import Foundation
import FirebaseAuth

struct LoginDTO {
    var email: String
    var password: String
}

internal protocol UserUseCaseType {
    func userSignUp(_ user: RegisterDTO) async throws -> Result<Bool, Error>
    func userSignIn(_ loginDTO: LoginDTO) async throws -> Result<UserModel, Error>
    func userSignOut() async throws
    func getUserSession() async throws -> UserModel?
}

internal final class UserUseCase: UserUseCaseType {
    private let repository: UserRepositoryType
    private let supabaseAuthService: SupabaseAuthService
    private let firebaseAuthService: FirebaseAuthService
    
    init(repository: UserRepositoryType = UserRepository(), supabaseAuthService: SupabaseAuthService = SupabaseAuthService.shared, firebaseAuthSercice: FirebaseAuthService = FirebaseAuthService.shared) {
        self.repository = repository
        self.supabaseAuthService = supabaseAuthService
        self.firebaseAuthService = firebaseAuthSercice
    }
    
    func userSignUp(_ user: RegisterDTO) async throws -> Result<Bool, Error> {
        do {
            try await repository.registerUser(user)
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func userSignIn(_ loginDTO: LoginDTO) async throws -> Result<UserModel, Error> {
        do {
            let authResult: AuthDataResult = try await withCheckedThrowingContinuation { continuation in
                firebaseAuthService.signIn(email: loginDTO.email, password: loginDTO.password) { result in
                    switch result {
                    case .success(let authDataResult):
                        continuation.resume(returning: authDataResult)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            guard let currentUser = Auth.auth().currentUser else {
                throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found"])
            }
            
            let userDTO = try await repository.getUser(uid: currentUser.uid)
            
            try await repository.setSession(authResult, userDTO: userDTO)
            
            
            guard let userModel = try await repository.getSession() else {
                throw NSError(domain: "SessionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User session could not be retrieved"])
            }
            return .success(userModel)
        } catch {
            return .failure(error)
        }
    }
    
    func userSignOut() async throws {
        do {
            //            try Auth.auth().signOut()
            try await repository.deleteSession()
        } catch {
            throw NSError(domain: "SignOutError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to sign out"])
        }
    }
    
    func getUserSession() async throws -> UserModel? {
        let localSession = try await repository.getSession()
        
        guard let firebaseSession = firebaseAuthService.getSessionUser() else {
            return nil
        }
        
        if localSession?.id == firebaseSession.uid {
            return localSession
        } else {
            try await repository.deleteSession()
            return nil
        }
    }
}
