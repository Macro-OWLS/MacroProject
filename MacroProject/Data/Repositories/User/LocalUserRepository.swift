//
//  LocalUserRepository.swift
//  MacroProject
//
//  Created by Agfi on 06/11/24.
//

import Foundation
import Supabase
import SwiftData
import FirebaseAuth

internal protocol LocalUserRepositoryType {
    func setSession(_ session: AuthDataResult) async throws
    func getSession() async throws -> UserModel?
    func deleteSession() async throws
    
}

internal final class LocalUserRepository: LocalUserRepositoryType {
    private let container = SwiftDataContextManager.shared.container
    
    @MainActor func setSession(_ session: AuthDataResult) async throws {
        let userEntity = UserEntity(
            id: session.user.uid,
            updatedAt: session.user.metadata.lastSignInDate,
            email: session.user.email,
            fullName: session.user.displayName,
            lastSignInAt: session.user.metadata.lastSignInDate,
            accessToken: session.credential?.accessToken,
            refreshToken: session.user.refreshToken
        )
        
        container?.mainContext.insert(userEntity)
        try container?.mainContext.save()
    }
    
    @MainActor func getSession() async throws -> UserModel? {
        let fetchDescriptor = FetchDescriptor<UserEntity>()
        guard let userEntity = try container?.mainContext.fetch(fetchDescriptor).first else {
            return nil
        }
        
        let userModel = UserModel(
            id: userEntity.id,
            updatedAt: userEntity.updatedAt,
            email: userEntity.email,
            fullName: userEntity.fullName,
            avatarURL: userEntity.avatarURL,
            website: userEntity.website,
            lastSignInAt: userEntity.lastSignInAt,
            accessToken: userEntity.accessToken,
            refreshToken: userEntity.refreshToken
        )

        return userModel
    }
    
    @MainActor func deleteSession() async throws {
        let fetchDescriptor = FetchDescriptor<UserEntity>()
        
        guard let userEntity = try container?.mainContext.fetch(fetchDescriptor).first else {
            throw NSError(domain: "DeleteSessionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No session found to delete"])
        }
        
        container?.mainContext.delete(userEntity)
        try container?.mainContext.save()
    }
}
