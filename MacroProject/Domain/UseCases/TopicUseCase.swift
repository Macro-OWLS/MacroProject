//
//  TopicUseCase.swift
//  MacroProject
//
//  Created by Agfi on 01/10/24.
//

import Foundation
import Combine

internal protocol TopicUseCaseType {
    func fetch() -> AnyPublisher<[TopicModel]?, NetworkError>
    func fetchTopicsByIds(ids: [String]) -> AnyPublisher<[TopicModel]?, NetworkError>
    func removeAllTopics() async throws
}

internal final class TopicUseCase: TopicUseCaseType {
    private let repository: TopicRepository
    
    init() {
        self.repository = TopicRepository()
    }
    
    func fetch() -> AnyPublisher<[TopicModel]?, NetworkError> {
        repository.fetch()
    }
    
    func fetchTopicsByIds(ids: [String]) -> AnyPublisher<[TopicModel]?, NetworkError> {
        repository.fetch(ids: ids)
    }
    
    func fetchTopicsBySection(section: String) -> AnyPublisher<[TopicModel]?, NetworkError> {
        repository.fetch(section: section)
    }
    
    func fetchTopicsByName(name: String) -> AnyPublisher<[TopicModel]?, NetworkError> {
        repository.fetch(name: name)
    }
    
    func removeAllTopics() async throws {
        do {
            try await repository.removeAllTopics()
        } catch {
            throw NSError(domain: "RemoveAllTopicsFailed", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to Reemove All Topics"])
        }
    }
}
