//
//  PhraseCardUseCase.swift
//  MacroProject
//
//  Created by Agfi on 08/10/24.
//

import Foundation
import Combine

internal protocol PhraseCardUseCaseType {
    func fetch() -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func create(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError>
    func delete(topicId: String) -> AnyPublisher<Bool, NetworkError>
    func update(id: String, nextLevelNumber: String) -> AnyPublisher<Bool, NetworkError>
}

internal final class PhraseCardUseCase: PhraseCardUseCaseType {
    private let repository: PhraseCardRepository = PhraseCardRepository()
    
    func fetch() -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        repository.fetch()
    }
    
    func create(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError> {
        repository.create(param: param)
    }
    

    func delete(topicId: String) -> AnyPublisher<Bool, NetworkError> {
        repository.delete(id: topicId)
    }
    
    func update(id: String, nextLevelNumber: String) -> AnyPublisher<Bool, NetworkError> {
        repository.update(id: id, nextLevelNumber: nextLevelNumber)
    }
}
