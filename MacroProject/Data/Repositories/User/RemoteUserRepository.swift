//
//  RemoteUserRepository.swift
//  MacroProject
//
//  Created by Agfi on 05/11/24.
//

import Foundation
import SwiftData

internal protocol RemoteUserRepositoryType {
    func fetchUserByUserID(userID: UUID) async throws -> UserModel
    func findUserByEmail(email: String) async throws -> UserModel
    func updateUser(_ user: UserModel) async throws
}

final class RemoteUserRepository: RemoteUserRepositoryType {
    private let supabase = SupabaseService.shared.getClient()
    
    func fetchUserByUserID(userID: UUID) async throws -> UserModel {
        do {
            let response: UserModel = try await supabase
                .database
                .from("profiles")
                .select()
                .eq("id", value: userID.uuidString)
                .single()
                .execute()
                .value
            
            return response
        } catch {
            throw error
        }
    }

    
    func findUserByEmail(email: String) async throws -> UserModel {
        do {
            let fetchedUser: UserModel = try await supabase
                .database
                .from("profiles")
                .select()
                .eq("email", value: email)
                .single()
                .execute()
                .value
            
            return fetchedUser
        } catch {
            throw error
        }
    }
    
    func updateUser(_ user: UserModel) async throws {
        do {
            try await supabase
                .database
                .from("profiles")
                .update([
                    "full_name": user.fullName,
                    "email": user.email,
                    "avatar_url": user.avatarURL
                ])
                .eq("id", value: user.id)
                .execute()
        } catch {
            throw error.toResponseError()
        }
    }
}
