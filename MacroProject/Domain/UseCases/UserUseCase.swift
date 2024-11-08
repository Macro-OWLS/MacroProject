//
//  UserUseCase.swift
//  MacroProject
//
//  Created by Agfi on 06/11/24.
//

import Foundation

struct LoginDTO {
    var email: String
    var password: String
}

internal protocol UserUseCaseType {
    func getUserByID(id: UUID) async throws -> Result<UserModel, Error>
    func getUserByEmail(email: String) async throws -> Result<UserModel, Error>
    func userSignUp(_ user: RegisterDTO) async throws -> Result<Bool, Error>
    func userSignIn(_ loginDTO: LoginDTO) async throws -> Result<Bool, Error>
}

internal final class UserUseCase: UserUseCaseType {
    private let repository: UserRepositoryType
    private let authService: AuthService
    
    init(repository: UserRepositoryType = UserRepository(), authService: AuthService = AuthService.shared) {
        self.repository = repository
        self.authService = authService
    }
    
    func getUserByID(id: UUID) async throws -> Result<UserModel, Error> {
        do {
            let user = try await repository.fetchUserByUserID(id: id)
            return .success(user)
        } catch {
            return .failure(error)
        }
    }
    
    func getUserByEmail(email: String) async throws -> Result<UserModel, any Error> {
        do {
            let user = try await repository.fetchUserByEmail(email: email)
            return .success(user)
        } catch {
            return .failure(error)
        }
    }
    
    func userSignUp(_ user: RegisterDTO) async throws -> Result<Bool, Error> {
        do {
            let userID = try await authService.register(user: user)
            
            let findUserByID = try await repository.fetchUserByUserID(id: userID)
            
            let updatedUser = UserModel(
                id: findUserByID.id,
                email: user.email,
                fullName: user.fullName,
                avatarURL: ""
            )
            try await repository.updateUser(updatedUser)
            
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func userSignIn(_ loginDTO: LoginDTO) async throws -> Result<Bool, Error> {
        do {
            let result = await authService.signIn(email: loginDTO.email, password: loginDTO.password)
            
            switch result {
            case .success: break
            case .failure: break
            }
            
            let session = try await authService.getSession()
            print("SESSIONNNN \n \(session)")
            
            try await repository.setSession(session)
            
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
}
