//
//  TopicUseCase.swift
//  MacroProject
//
//  Created by Agfi on 01/10/24.
//

import Foundation
import Combine

internal protocol TopicUseCaseType {
    func fetch() -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func save() -> AnyPublisher<Bool, NetworkError>
    func delete(id: String) -> AnyPublisher<Bool, NetworkError>
}

internal final class TopicUseCase: TopicUseCaseType {
    private let repository: TopicRepository
    
    init(repository: TopicRepository) {
        self.repository = repository
    }
    
    func fetch() -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        repository.fetch()
        
    }
    
    func save() -> AnyPublisher<Bool, NetworkError> {
        repository.save()
    }
    
    func delete(id: String) -> AnyPublisher<Bool, NetworkError> {
        repository.delete(id: id)
    }
}
