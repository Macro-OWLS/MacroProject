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
    func save() -> AnyPublisher<Bool, NetworkError>
    func delete(topicId: String) -> AnyPublisher<Bool, NetworkError>
}

internal final class PhraseCardUseCase: PhraseCardUseCaseType {
    private let repository: PhraseCardRepository = PhraseCardRepository()
    
    func fetch() -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        repository.fetch()
    }
    
    func create(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError> {
        repository.create(param: param)
    }
    
    func save() -> AnyPublisher<Bool, NetworkError> {
        repository.save()
    }
    
    func delete(topicId: String) -> AnyPublisher<Bool, NetworkError> {
        repository.delete(id: topicId)
    }
}
