//
//  RemoteUserPhraseRepository.swift
//  MacroProject
//
//  Created by Agfi on 07/11/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

internal protocol RemoteUserPhraseRepositoryType {
    func getFilteredPhraseByUserID(userID: UUID) async throws -> [UserPhraseCardModel]
    func createPhraseToReview(phrase: UserPhraseCardModel) async throws
}

final class RemoteUserPhraseRepository: RemoteUserPhraseRepositoryType {
    private let supabase = SupabaseService.shared.getClient()
    private let db = Firestore.firestore()
    
    func getFilteredPhraseByUserID(userID: UUID) async throws -> [UserPhraseCardModel] {
        let query = """
            SELECT p.*
            FROM Phrases p
            LEFT JOIN Profile_Phrase pp ON p.id = pp.phrase_id AND pp.user_id = '\(userID.uuidString)'
            WHERE pp.phrase_id IS NULL
            """
        
        do {
            let result: [UserPhraseCardModel] = try await supabase.database.rpc(query).execute().value
            return result
        } catch {
            throw error
        }
    }
    
    func createPhraseToReview(phrase: UserPhraseCardModel) async throws {
        do {
            let phraseData: [String: Any] = [
                "id": UUID().uuidString,
                "profile_id": phrase.profileID,
                "phrase_id": phrase.phraseID,
                "vocabulary": phrase.vocabulary,
                "phrase": phrase.phrase,
                "translation": phrase.translation,
                "prevLevel": phrase.prevLevel,
                "nextLevel": phrase.nextLevel,
                "lastReviewedDate": phrase.lastReviewedDate ?? FieldValue.serverTimestamp(),
                "nextReviewDate": phrase.nextReviewDate ?? FieldValue.serverTimestamp(),
                "createdAt": phrase.createdAt ?? FieldValue.serverTimestamp()
            ]
            try await db.collection("Profile_Phrase").document().setData(phraseData)
        } catch {
            throw error
        }
    }
    
    func updatePhraseToReview(id: String, with result: UpdateProfilePhraseReview) async throws {
        do {
            let updatedData: [String: Any] = [
                "prevLevel": result.prevLevel,
                "nextLevel": result.nextLevel,
                "lastReviewedDate": Timestamp(date: result.lastReviewedDate),
                "nextReviewDate": Timestamp(date: result.nextReviewDate)
            ]
            try await db.collection("Profile_Phrase").document(id).updateData(updatedData)
        } catch {
            throw error
        }
    }
}

struct UpdateProfilePhraseReview {
    var prevLevel: String
    var nextLevel: String
    var lastReviewedDate: Date
    var nextReviewDate: Date
}
