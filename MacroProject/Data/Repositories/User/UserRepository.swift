//
//  UserRepository.swift
//  MacroProject
//
//  Created by Agfi on 06/11/24.
//

import Foundation
import Supabase

internal protocol UserRepositoryType {
    func fetchUserByUserID(id: UUID) async throws -> UserModel
    func fetchUserByEmail(email: String) async throws -> UserModel
    func updateUser(_ user: UserModel) async throws
    
    func setSession(_ session: Session) async throws
}

internal final class UserRepository: UserRepositoryType {
    private let remoteRepository: RemoteUserRepositoryType
    private let localRepository: LocalUserRepositoryType
    
    init(remoteRepository: RemoteUserRepositoryType = RemoteUserRepository(), localRepository: LocalUserRepositoryType = LocalUserRepository()) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
    }
    
    func fetchUserByUserID(id: UUID) async throws -> UserModel {
        return try await remoteRepository.fetchUserByUserID(userID: id)
    }
    
    func fetchUserByEmail(email: String) async throws -> UserModel {
        return try await remoteRepository.findUserByEmail(email: email)
    }
    
    func updateUser(_ user: UserModel) async throws {
        return try await remoteRepository.updateUser(user)
    }
    
    func setSession(_ session: Session) async throws {
        return try await localRepository.setSession(session)
    }
    
    func getSession() async throws -> UserModel? {
        return try await localRepository.getSession()
    }
}
