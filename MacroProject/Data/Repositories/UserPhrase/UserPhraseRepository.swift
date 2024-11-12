//
//  UserPhraseRepository.swift
//  MacroProject
//
//  Created by Agfi on 07/11/24.
//

import Foundation

internal protocol UserPhraseRepositoryType {
    func getFilteredPhraseByUserID(userID: String) async throws -> [UserPhraseCardModel]
    func createPhraseToReview(phrase: UserPhraseCardModel) async throws
    func updatePhraseToReview(userID: String, phraseID: String, result: UpdateUserPhraseReviewDTO) async throws
}

internal final class UserPhraseRepository: UserPhraseRepositoryType {
    private let remoteRepository: RemoteUserPhraseRepositoryType
    
    init(remoteRepository: RemoteUserPhraseRepositoryType = RemoteUserPhraseRepository()) {
        self.remoteRepository = remoteRepository
    }
    
    func getFilteredPhraseByUserID(userID: String) async throws -> [UserPhraseCardModel] {
        return try await remoteRepository.getFilteredPhraseByUserID(userID: userID)
    }
    
    func createPhraseToReview(phrase: UserPhraseCardModel) async throws {
        return try await remoteRepository.createPhraseToReview(phrase: phrase)
    }
    
    func updatePhraseToReview(userID: String, phraseID: String, result: UpdateUserPhraseReviewDTO) async throws {
        return try await remoteRepository.updatePhraseToReview(userID: userID, phraseID: phraseID, result: result)
    }
}
