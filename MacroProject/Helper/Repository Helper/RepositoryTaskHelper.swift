//
//  RepositoryTaskHelper.swift
//  MacroProject
//
//  Created by Agfi on 24/10/24.
//

import Combine

internal final class RepositoryTaskHelper {
    private let syncHelper: SynchronizationHelper
    
    init(syncHelper: SynchronizationHelper = SynchronizationHelper()) {
        self.syncHelper = syncHelper
    }
    
    /// Executes an asynchronous task with optional synchronization.
    func performTask<T>(withSync: Bool = false, _ action: @escaping () async throws -> T) -> AnyPublisher<T, NetworkError> {
        return Future<T, NetworkError> { promise in
            Task { @MainActor in
                do {
                    if withSync {
                        // Ensure synchronization if specified
                        try await self.syncHelper.ensureSynchronized()
                    }
                    let result = try await action()
                    promise(.success(result))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
