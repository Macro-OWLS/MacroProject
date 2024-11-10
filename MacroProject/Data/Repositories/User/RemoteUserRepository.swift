//
//  RemoteUserRepository.swift
//  MacroProject
//
//  Created by Agfi on 05/11/24.
//

import Foundation
import SwiftData
import FirebaseAuth
import FirebaseFirestore

internal protocol RemoteUserRepositoryType {
    func registerUser(_ user: RegisterDTO) async throws
}

final class RemoteUserRepository: RemoteUserRepositoryType {
    private let supabase = SupabaseService.shared.getClient()
    private let firebase = FirebaseAuthService.shared
    private let db = Firestore.firestore()
    
    func registerUser(_ userRegisterInput: RegisterDTO) async throws {
        do {
            guard let authResult = await firebase.register(registerInput: userRegisterInput) else {
                return print("Failed to register user")
            }
            
            authResult.user.displayName = userRegisterInput.fullName
            print("DISPLAY NAME: \(String(describing: authResult.user.displayName))")
            
            let userData: [String: Any] = [
                "fullName": userRegisterInput.fullName,
                "email": userRegisterInput.email,
                "streak": 0,
                "createdAt": FieldValue.serverTimestamp()
            ]
            try await db.collection("users").document(authResult.user.uid).setData(userData)
        } catch {
            throw error
        }
    }
}
