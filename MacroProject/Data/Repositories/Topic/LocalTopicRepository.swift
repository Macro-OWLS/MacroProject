//
//  LocalTopicRepository.swift
//  MacroProject
//
//  Created by Agfi on 11/10/24.
//

import Foundation
import SwiftData
import Supabase

internal protocol LocalRepositoryType {
    func fetchTopics() async throws -> [TopicModel]?
    func createTopic(_ topic: TopicModel) async throws
    func updateTopic(_ topic: TopicModel) async throws
    func deleteTopic(id: String) async throws
}

final class LocalRepository: LocalRepositoryType {
    private let container = SwiftDataContextManager.shared.container
    
    @MainActor func fetchTopics() throws -> [TopicModel]? {
        let fetchDescriptor = FetchDescriptor<TopicEntity>()
        let topics = try container?.mainContext.fetch(fetchDescriptor)
        return topics?.compactMap { $0.toDomain() }
    }

    @MainActor func createTopic(_ topic: TopicModel) throws {
        let entity = TopicEntity(id: topic.id, name: topic.name, desc: topic.desc, isAddedToLibraryDeck: topic.isAddedToLibraryDeck)
        container?.mainContext.insert(entity)
        try container?.mainContext.save()
    }

    @MainActor func updateTopic(_ topic: TopicModel) throws {
        let id = topic.id
        let fetchDescriptor = FetchDescriptor<TopicEntity>(predicate: #Predicate { $0.id == id })
        if let entity = try container?.mainContext.fetch(fetchDescriptor).first {
            entity.name = topic.name
            entity.desc = topic.desc
            entity.isAddedToLibraryDeck = topic.isAddedToLibraryDeck
            try container?.mainContext.save()
        } else {
            throw NetworkError.noData
        }
    }

    @MainActor func deleteTopic(id: String) throws {
        let fetchDescriptor = FetchDescriptor<TopicEntity>(predicate: #Predicate { $0.id == id })
        if let entity = try container?.mainContext.fetch(fetchDescriptor).first {
            container?.mainContext.delete(entity)
            try container?.mainContext.save()
        } else {
            throw NetworkError.noData
        }
    }
}
