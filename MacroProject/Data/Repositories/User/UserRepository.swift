//
//  UserRepository.swift
//  MacroProject
//
//  Created by Agfi on 06/11/24.
//

import Foundation
import Supabase
import FirebaseAuth

internal protocol UserRepositoryType {
    func registerUser(_ user: RegisterDTO) async throws
    func setSession(_ session: AuthDataResult) async throws
    func getSession() async throws -> UserModel?
    func deleteSession() async throws
}

internal final class UserRepository: UserRepositoryType {
    private let remoteRepository: RemoteUserRepositoryType
    private let localRepository: LocalUserRepositoryType
    
    init(remoteRepository: RemoteUserRepositoryType = RemoteUserRepository(), localRepository: LocalUserRepositoryType = LocalUserRepository()) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
    }
    
    func registerUser(_ user: RegisterDTO) async throws {
        return try await remoteRepository.registerUser(user)
    }
    
    func setSession(_ session: AuthDataResult) async throws {
        return try await localRepository.setSession(session)
    }
    
    func getSession() async throws -> UserModel? {
        return try await localRepository.getSession()
    }
    
    func deleteSession() async throws {
        try await localRepository.deleteSession()
    }
}
