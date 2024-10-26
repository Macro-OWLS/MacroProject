//
//  PhraseCardUseCase.swift
//  MacroProject
//
//  Created by Agfi on 08/10/24.
//

import Foundation
import Combine

internal protocol PhraseCardUseCaseType {
    func fetchByID(id: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func fetchByTopicID(topicID: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func fetchByLevel(levelNumber: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func fetchByLevelAndDate(levelNumber: String, Date: Date?, dateType: DateType) -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func fetchByTopicLevelAndDate(topicID: String, levelNumber: String, date: Date, dateType: DateType) -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func update(id: String, result: PhraseResult) -> AnyPublisher<Bool, NetworkError>
    
//    func create(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError>
//    func delete(topicID: String) -> AnyPublisher<Bool, NetworkError>
//    func fetchByLevelAndId(topicID: String, levelNumber: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError>
}

internal final class PhraseCardUseCase: PhraseCardUseCaseType {
    
    
    private let repository: PhraseCardRepository
    
    init() {
        self.repository = PhraseCardRepository()
    }
    
    func fetchByID(id: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        repository.fetch(id: id)
    }
    
    func fetchByTopicID(topicID: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        repository.fetch(topicID: topicID)
    }
    
    func fetchByLevel(levelNumber: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        repository.fetch(levelNumber: levelNumber)
    }
    
    func fetchByLevelAndDate(levelNumber: String, Date: Date?, dateType: DateType) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        repository.fetch(levelNumber: levelNumber, date: Date, dateType: dateType)
    }
    
    func fetchByTopicLevelAndDate(topicID: String, levelNumber: String, date: Date, dateType: DateType) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        repository.fetch(topicID: topicID, levelNumber: levelNumber, date: date, dateType: dateType)
    }
    
    func update(id: String, result: PhraseResult) -> AnyPublisher<Bool, NetworkError> {
        repository.update(id: id, result: result)
    }
    
//    func create(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError> {
//        repository.create(param: param)
//    }
//
//    func delete(topicID: String) -> AnyPublisher<Bool, NetworkError> {
//        repository.delete(id: topicID)
//    }
//
//    
//    func fetchByLevelAndId(topicID: String, levelNumber: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
//        repository.fetchPhrase(topicID: topicID, levelNumber: levelNumber)
//    }
}
