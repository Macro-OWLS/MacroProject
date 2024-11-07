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
}
