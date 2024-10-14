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

    private var hasSynchronized: Bool = false

    init(remoteRepository: RemoteRepositoryType = RemoteRepository(), localRepository: LocalRepositoryType = LocalRepository(), remotePhraseRepository: RemotePhraseRepositoryType = RemotePhraseRepository(), localPhraseRepository: LocalPhraseRepositoryType = LocalPhraseRepository()) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
        self.remotePhraseRepository = remotePhraseRepository
        self.localPhraseRepository = localPhraseRepository
    }

    func ensureSynchronized() async throws {
        guard !self.hasSynchronized && SyncManager.isFirstAppOpen() else { return }
        try await self.synchronizeRemoteToLocal()
        SyncManager.markAsSynchronized()
        self.hasSynchronized = true
        
    }
    
    private func synchronizeRemoteToLocal() async throws {
        let remoteTopics = try await remoteRepository.fetchTopics()
        for topic in remoteTopics {
            try await localRepository.createTopic(topic)
        }
        
        guard let remotePhrases = try await remotePhraseRepository.fetchPhrase() else {return}
        for phrase in remotePhrases {
            try await localPhraseRepository.createPhrase(phrase)
//            print("repo fetch \(String(describing: phrase))")
        }
    }
}
