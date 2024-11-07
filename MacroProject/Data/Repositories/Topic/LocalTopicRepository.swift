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
    func fetchTopics(ids: [String]) async throws -> [TopicModel]?
    func fetchTopics(section: String) async throws -> [TopicModel]?
    func fetchTopics(name: String) async throws -> [TopicModel]?
    func createTopic(_ topic: TopicModel) async throws
}

final class LocalRepository: LocalRepositoryType {
    private let container = SwiftDataContextManager.shared.container
    
    @MainActor func fetchTopics() throws -> [TopicModel]? {
        let fetchDescriptor = FetchDescriptor<TopicEntity>()
        let topics = try container?.mainContext.fetch(fetchDescriptor)
        return topics?.compactMap { $0.toDomain() }
    }
    
    @MainActor func fetchTopics(ids: [String]) async throws -> [TopicModel]? {
        let fetchDescriptor = FetchDescriptor<TopicEntity>()
        let topics = try container?.mainContext.fetch(fetchDescriptor)
        let domainTopics = topics?.compactMap { $0.toDomain() }
        return TopicHelper.filterTopicsByMultipleIds(from: domainTopics ?? [], ids: ids)
    }

    @MainActor func fetchTopics(section: String) async throws -> [TopicModel]? {
        let fetchDescriptor = FetchDescriptor<TopicEntity>()
        let topics = try container?.mainContext.fetch(fetchDescriptor)
        let domainTopics = topics?.compactMap { $0.toDomain() }
        return TopicHelper.filterTopics(using: [(.section, section)], from: domainTopics ?? [])
    }
    
    @MainActor func fetchTopics(name: String) async throws -> [TopicModel]? {
        let fetchDescriptor = FetchDescriptor<TopicEntity>()
        let topics = try container?.mainContext.fetch(fetchDescriptor)
        let domainTopics = topics?.compactMap { $0.toDomain() }
        return TopicHelper.filterTopics(using: [(.name, name)], from: domainTopics ?? [])
    }
    
    @MainActor func createTopic(_ topic: TopicModel) throws {
        let entity = TopicEntity(id: topic.id, name: topic.name, icon: topic.icon, desc: topic.desc, isAddedToLibraryDeck: topic.isAddedToLibraryDeck, section: topic.section)
        container?.mainContext.insert(entity)
        try container?.mainContext.save()
    }
}
