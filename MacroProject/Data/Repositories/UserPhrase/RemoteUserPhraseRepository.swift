//
//  RemoteUserPhraseRepository.swift
//  MacroProject
//
//  Created by Agfi on 07/11/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

internal protocol RemoteUserPhraseRepositoryType {
    func getFilteredPhraseByUserID(userID: UUID) async throws -> [UserPhraseCardModel]
    func createPhraseToReview(phrase: UserPhraseCardModel) async throws
    func updatePhraseToReview(userID: String, phraseID: String, result: UpdateUserPhraseReviewDTO) async throws
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
            let userPhraseData: [String: Any] = [
                "id": UUID().uuidString,
                "profile_id": phrase.profileID,
                "phrase_id": phrase.phraseID,
                "vocabulary": phrase.vocabulary,
                "phrase": phrase.phrase,
                "translation": phrase.translation,
                "prevLevel": phrase.prevLevel,
                "nextLevel": phrase.nextLevel,
                "lastReviewDate": phrase.lastReviewedDate ?? Date(),
                "nextReviewDate": phrase.nextReviewDate ?? Date()
            ]
            try await db.collection("user_phrase").addDocument(data: userPhraseData)
        } catch {
            throw error
        }
    }
    
    func updatePhraseToReview(userID: String, phraseID: String, result: UpdateUserPhraseReviewDTO) async throws {
        do {
            let querySnapshot = try await db.collection("user_phrase")
                .whereField("phrase_id", isEqualTo: phraseID)
                .whereField("profile_id", isEqualTo: userID)
                .getDocuments()
            
            if let document = querySnapshot.documents.first {
                let updatedUserPhraseData: [String: Any] = [
                    "prevLevel": result.prevLevel,
                    "nextLevel": result.nextLevel,
                    "lastReviewDate": result.lastReviewedDate,
                    "nextReviewDate": result.nextReviewDate
                ]
                
                // Update the document with the new data
                try await document.reference.setData(updatedUserPhraseData, merge: true)
            } else {
                throw NSError(domain: "PhraseNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Phrase with given ID not found"])
            }
        } catch {
            throw error
        }
    }
}
