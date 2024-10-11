//
//  SynchronizationHelper.swift
//  MacroProject
//
//  Created by Agfi on 11/10/24.
//

final class SynchronizationHelper {
    private let remoteRepository: RemoteRepositoryType
    private let localRepository: LocalRepositoryType

    private var hasSynchronized: Bool = false

    init(remoteRepository: RemoteRepositoryType = RemoteRepository(), localRepository: LocalRepositoryType = LocalRepository()) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
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
    }
}
