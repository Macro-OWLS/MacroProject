//
//  UserPhraseRepository.swift
//  MacroProject
//
//  Created by Agfi on 07/11/24.
//

import Foundation

internal protocol UserPhraseRepositoryType {
    func getFilteredPhraseByUserID(userID: UUID) async throws -> [UserPhraseCardModel]
    func createPhraseToReview(phrase: UserPhraseCardModel) async throws
}

internal final class UserPhraseRepository: UserPhraseRepositoryType {
    private let remoteRepository: RemoteUserPhraseRepositoryType
    
    init(remoteRepository: RemoteUserPhraseRepositoryType = RemoteUserPhraseRepository()) {
        self.remoteRepository = remoteRepository
    }
    
    func getFilteredPhraseByUserID(userID: UUID) async throws -> [UserPhraseCardModel] {
        return try await remoteRepository.getFilteredPhraseByUserID(userID: userID)
    }
    
    func createPhraseToReview(phrase: UserPhraseCardModel) async throws {
        return try await remoteRepository.createPhraseToReview(phrase: phrase)
    }
}
