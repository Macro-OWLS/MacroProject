//
//  UserPhraseUseCase.swift
//  MacroProject
//
//  Created by Agfi on 07/11/24.
//

import Foundation

internal protocol UserPhraseUseCaseType {
    func getFilteredPhraseByUserID(userID: String) async throws -> Result<[UserPhraseCardModel], Error>
    func createPhraseToReview(phrase: UserPhraseCardModel) async throws
    func updatePhraseToReview(userID: String, phraseID: String, result: UpdateUserPhraseReviewDTO) async throws
}

internal final class UserPhraseUseCase: UserPhraseUseCaseType {
    private let repository: UserPhraseRepositoryType
    
    init(repository: UserPhraseRepositoryType = UserPhraseRepository()) {
        self.repository = repository
    }
    
    func getFilteredPhraseByUserID(userID: String) async throws -> Result<[UserPhraseCardModel], Error> {
        do {
            let filteredPhraseByUserID = try await repository.getFilteredPhraseByUserID(userID: userID)
            return .success(filteredPhraseByUserID)
        } catch {
            return .failure(error)
        }
    }
    
    func createPhraseToReview(phrase: UserPhraseCardModel) async throws {
        try await repository.createPhraseToReview(phrase: phrase)
    }
    
    func updatePhraseToReview(userID: String, phraseID: String, result: UpdateUserPhraseReviewDTO) async throws {
        try await repository.updatePhraseToReview(userID: userID, phraseID: phraseID, result: result)
    }
}
