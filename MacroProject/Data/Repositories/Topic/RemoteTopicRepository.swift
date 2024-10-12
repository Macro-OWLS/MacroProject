//
//  RemoteTopicRepository.swift
//  MacroProject
//
//  Created by Agfi on 11/10/24.
//

import Foundation

internal protocol RemoteRepositoryType {
    func fetchTopics() async throws -> [TopicModel]
    func createTopic(_ topic: TopicModel) async throws
    func updateTopic(_ topic: TopicModel) async throws
}

internal final class RemoteRepository: RemoteRepositoryType {
    private let supabase = SupabaseService.shared.getClient()
    
    func fetchTopics() async throws -> [TopicModel] {
        do {
            let fetchedTopics: [TopicModel] = try await supabase
                .database
                .from("Topics")
                .select()
                .execute()
                .value

            return fetchedTopics
        } catch {
            throw NetworkError.noData
        }
    }

    func createTopic(_ topic: TopicModel) async throws {
        do {
            try await supabase
                .database
                .from("Topics")
                .insert([
                    "id": topic.id,
                    "name": topic.name,
                    "desc": topic.desc,
                    "isAddedToLibraryDeck": topic.isAddedToLibraryDeck ? "true" : "false"
                ]).execute()
        } catch {
            throw NetworkError.noData
        }
    }

    func updateTopic(_ topic: TopicModel) async throws {
        do {
            try await supabase
                .database
                .from("Topics")
                .update([
                    "name": topic.name,
                    "desc": topic.desc,
                    "isAddedToLibraryDeck": topic.isAddedToLibraryDeck ? "true" : "false"
                ])
                .eq("id", value: topic.id)
                .execute()
        } catch {
            throw NetworkError.noData
        }
    }
}
