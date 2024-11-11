//
//  SynchronizationHelper.swift
//  MacroProject
//
//  Created by Agfi on 11/10/24.
//

final class SynchronizationHelper {
    private let remoteRepository: RemoteRepositoryType
    private let localRepository: LocalRepositoryType
    private let remotePhraseRepository: RemotePhraseRepositoryType
    private let localPhraseRepository: LocalPhraseRepositoryType
    private let userPhraseRepository: UserPhraseRepositoryType
    
    private let firebaseAuthService: FirebaseAuthService

    private var hasSynchronized: Bool = false

    init(remoteRepository: RemoteRepositoryType = RemoteRepository(), localRepository: LocalRepositoryType = LocalRepository(), remotePhraseRepository: RemotePhraseRepositoryType = RemotePhraseRepository(), localPhraseRepository: LocalPhraseRepositoryType = LocalPhraseRepository(), userPhraseRepository: UserPhraseRepositoryType = UserPhraseRepository(), firebaseAuthService: FirebaseAuthService = FirebaseAuthService.shared) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
        self.remotePhraseRepository = remotePhraseRepository
        self.localPhraseRepository = localPhraseRepository
        self.userPhraseRepository = userPhraseRepository
        self.firebaseAuthService = firebaseAuthService
    }

    func ensureSynchronized() async throws {
        guard !self.hasSynchronized && SyncManager.isFirstAppOpen() else { return }
        try await self.synchronizeRemoteToLocal()
        SyncManager.markAsSynchronized()
        self.hasSynchronized = true
        
    }
    
    private func synchronizeRemoteToLocal() async throws {
        let remoteMasterTopics = try await remoteRepository.fetchTopics()
        for topic in remoteMasterTopics {
            try await localRepository.createTopic(topic)
        }
        
        let remoteMasterPhrases = try await remotePhraseRepository.fetchPhrase()
        let remoteUserPhrases = try await userPhraseRepository.getFilteredPhraseByUserID(userID: firebaseAuthService.getSessionUser()?.uid ?? "")
        let userPhraseIDs = Set(remoteUserPhrases.map { $0.phraseID })
        
        let curatedPhrases = remoteMasterPhrases.filter { !userPhraseIDs.contains($0.id) }
        print(userPhraseIDs)
        
        for phrase in curatedPhrases {
            try await localPhraseRepository.createPhrase(phrase)
        }
        for phrase in remoteUserPhrases {
            let parsePhraseCardModel = PhraseCardModel(
                id: phrase.id,
                topicID: phrase.topicID,
                vocabulary: phrase.vocabulary,
                phrase: phrase.phrase,
                translation: phrase.translation,
                isReviewPhase: true,
                levelNumber: phrase.prevLevel,
                prevLevel: phrase.prevLevel,
                nextLevel: phrase.nextLevel,
                lastReviewedDate: phrase.lastReviewedDate,
                nextReviewDate: phrase.nextReviewDate
            )
            try await localPhraseRepository.createPhrase(parsePhraseCardModel)
        }
    }
}
