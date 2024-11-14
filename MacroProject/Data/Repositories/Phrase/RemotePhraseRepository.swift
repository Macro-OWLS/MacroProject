//
//  RemotePhraseRepository.swift
//  MacroProject
//
//  Created by Ages on 12/10/24.
//
import Foundation
import SwiftData
import FirebaseCore
import FirebaseFirestore
import Supabase

internal protocol RemotePhraseRepositoryType {
    func fetchPhrase() async throws -> [PhraseCardModel]
}

final class RemotePhraseRepository: RemotePhraseRepositoryType {
    private let supabase = SupabaseService.shared.getClient()
    private let database = Firestore.firestore()
    
    func fetchPhrase() async throws -> [PhraseCardModel] {
        let docRef = database.collection("Phrases")
        
        do {
            let querySnapshot = try await docRef.getDocuments()
            
            let fetchedPhrases = querySnapshot.documents.compactMap { document in
                let data = document.data()
                
                return PhraseCardModel(
                    id: document.documentID,
                    topicID: data["topicID"] as? String ?? "",
                    vocabulary: data["vocabulary"] as? String ?? "",
                    phrase: data["phrase"] as? String ?? "",
                    translation: data["translation"] as? String ?? "",
                    vocabularyTranslation: data["vocabularyTranslation"] as? String ?? "",
                    isReviewPhase: data["isReviewPhase"] as? Bool ?? false,
                    levelNumber: data["levelNumber"] as? String ?? "",
                    prevLevel: data["prevlevel"] as? String,
                    nextLevel: data["nextlevel"] as? String,
                    lastReviewedDate: (data["lastReviewedDate"] as? Timestamp)?.dateValue(),
                    nextReviewDate: (data["nextReviewDate"] as? Timestamp)?.dateValue()
                )
            }
            
            print("Fetched phrases from Firestore: \(fetchedPhrases)")
            return fetchedPhrases
        } catch {
            print("Error getting documents: \(error.localizedDescription)")
            throw NetworkError.noData
        }
    }
}
