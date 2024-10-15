//
//  PhraseCardUseCase.swift
//  MacroProject
//
//  Created by Agfi on 08/10/24.
//

import Foundation
import Combine

internal protocol PhraseCardUseCaseType {
    func fetch(topicID: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func create(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError>
    func delete(topicID: String) -> AnyPublisher<Bool, NetworkError>
    func update(id: String, nextLevelNumber: String) -> AnyPublisher<Bool, NetworkError>
    func fetchByLevelAndId(topicID: String, levelNumber: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError>
}

internal final class PhraseCardUseCase: PhraseCardUseCaseType {
    private let repository: PhraseCardRepository
    
    init(repository: PhraseCardRepository) {
        self.repository = repository
    }
    
    func fetch(topicID: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        repository.fetch(topicID: topicID)
    }
    
    func create(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError> {
        repository.create(param: param)
    }

    func delete(topicID: String) -> AnyPublisher<Bool, NetworkError> {
        repository.delete(id: topicID)
    }
    
    func update(id: String, nextLevelNumber: String) -> AnyPublisher<Bool, NetworkError> {
        repository.update(id: id, nextLevelNumber: nextLevelNumber)
    }
    
    func fetchByLevelAndId(topicID: String, levelNumber: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        repository.fetchPhrase(topicID: topicID, levelNumber: levelNumber)
    }
    
    func fetchByLevel(levelNumber: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        repository.fetch(levelNumber: levelNumber)
    }
}
