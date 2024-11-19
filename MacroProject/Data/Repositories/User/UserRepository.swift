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
    func updateUserStreak(uid: String, streak: Int, isStreakOnGoing: Bool, updateAT: Date, isStreakComplete: Bool) async throws
    func updateUserTarget(uid: String, targetStreak: Int, lastTargetUpdated: Date) async throws
    func deleteAccount(uid: String) async throws
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
    
    func updateUserStreak(uid: String, streak: Int, isStreakOnGoing: Bool, updateAT: Date, isStreakComplete: Bool) async throws {
        try await remoteRepository.updateUserStreak(uid: uid, streak: streak, isStreakOnGoing: isStreakOnGoing, updateAT: updateAT, isStreakComplete: isStreakComplete)
    }
    
    func updateUserTarget(uid: String, targetStreak: Int, lastTargetUpdated: Date) async throws {
        try await remoteRepository.updateUserTarget(uid: uid, targetStreak: targetStreak, lastTargetUpdated: lastTargetUpdated)
    }
    
    func deleteAccount(uid: String) async throws {
        try await remoteRepository.deleteAccount(uid: uid)
    }
}
