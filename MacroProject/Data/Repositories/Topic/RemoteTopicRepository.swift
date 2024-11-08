//
//  RemoteTopicRepository.swift
//  MacroProject
//
//  Created by Agfi on 11/10/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import Supabase

internal protocol RemoteRepositoryType {
    func fetchTopics() async throws -> [TopicModel]
}


internal final class RemoteRepository: RemoteRepositoryType {
    private let supabase = SupabaseService.shared.getClient()
    private let database = Firestore.firestore()
    
    func fetchTopics() async throws -> [TopicModel] {
        let docRef = database.collection("Topics")
        
        do {
            let querySnapshot = try await docRef.getDocuments()
            
            let fetchedTopics = querySnapshot.documents.compactMap { document in
                let data = document.data()
                
                return TopicModel(
                    id: data["topicID"] as? String ?? "",
                    name: data["topicName"] as? String ?? "",
                    icon: data["topicicon"] as? String ?? "",
                    desc: data["topicDesc"] as? String ?? "",
                    isAddedToStudyDeck: data["isAddedToReview"] as? Bool ?? false,
                    section: data["topicSection"] as? String ?? ""
                )
            }
            print("fetch firebase topics: \(fetchedTopics)")
            return fetchedTopics
        } catch {
            print("Error getting documents: \(error.localizedDescription)")
            throw NetworkError.noData
        }
    }
}
