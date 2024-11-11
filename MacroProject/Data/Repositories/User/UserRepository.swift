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
    func getUser(uid: String) async throws -> UserDTO
    func setSession(_ session: AuthDataResult, userDTO: UserDTO) async throws
    func getSession() async throws -> UserModel?
    func deleteSession() async throws
    func updateUser(uid: String, streak: Int?) async throws
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
    
    func setSession(_ session: AuthDataResult, userDTO: UserDTO) async throws {
        return try await localRepository.setSession(session, userDTO: userDTO)
    }
    
    func getSession() async throws -> UserModel? {
        return try await localRepository.getSession()
    }
    
    func deleteSession() async throws {
        try await localRepository.deleteSession()
    }
    
    func getUser(uid: String) async throws -> UserDTO {
        try await remoteRepository.getUser(uid: uid)
    }
    
    func updateUser(uid: String, streak: Int?) async throws {
        try await remoteRepository.updateUser(uid: uid, streak: streak)
    }
}
