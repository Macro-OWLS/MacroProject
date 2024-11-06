//
//  LocalUserRepository.swift
//  MacroProject
//
//  Created by Agfi on 06/11/24.
//

import Foundation
import Supabase
import SwiftData

internal protocol LocalUserRepositoryType {
    func setSession(_ session: Session) async throws
    func getSession() async throws -> UserModel?
    
}

internal final class LocalUserRepository: LocalUserRepositoryType {
    private let container = SwiftDataContextManager.shared.container
    
    @MainActor func setSession(_ session: Session) async throws {
        let userEntity = UserEntity(
            id: session.user.id.uuidString,
            updatedAt: session.user.updatedAt,
            email: session.user.email,
            fullName: session.user.userMetadata["fullName"]?.stringValue,
            lastSignInAt: session.user.lastSignInAt,
            accessToken: session.accessToken,
            refreshToken: session.refreshToken
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
            website: userEntity.website
        )

        return userModel
    }
}
