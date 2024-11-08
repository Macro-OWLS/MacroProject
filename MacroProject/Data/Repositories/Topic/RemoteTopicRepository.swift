//
//  RemoteTopicRepository.swift
//  MacroProject
//
//  Created by Agfi on 11/10/24.
//

import Foundation
import Supabase

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
                    "icon": topic.icon,
                    "desc": topic.desc,
                    "isAddedToStudyDeck": topic.isAddedToStudyDeck ? "true" : "false",
                    "section": topic.section,
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
                    "isAddedToStudyDeck": topic.isAddedToStudyDeck ? "true" : "false",
                    "section": topic.section
                ])
                .eq("id", value: topic.id)
                .execute()
        } catch {
            throw NetworkError.noData
        }
    }
}
