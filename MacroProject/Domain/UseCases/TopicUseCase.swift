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
}

internal final class TopicUseCase: TopicUseCaseType {
    private let repository: TopicRepository
    
    init(repository: TopicRepository) {
        self.repository = repository
    }
    
    func fetch() -> AnyPublisher<[TopicModel]?, NetworkError> {
        repository.fetch()
    }
}
