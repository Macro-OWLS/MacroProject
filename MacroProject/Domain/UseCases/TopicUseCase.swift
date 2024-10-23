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
    func create(param: TopicModel) -> AnyPublisher<Bool, NetworkError>
    func delete(id: String) -> AnyPublisher<Bool, NetworkError>
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
    
    func create(param: TopicModel) -> AnyPublisher<Bool, NetworkError> {
        repository.create(param: param)
    }
    
    func delete(id: String) -> AnyPublisher<Bool, NetworkError> {
        repository.delete(id: id)
    }
}
