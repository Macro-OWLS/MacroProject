//
//  SwiftDataContextManager.swift
//  MacroProject
//
//  Created by Agfi on 18/09/24.
//

import Foundation
import SwiftData

public class SwiftDataContextManager {
    public static var shared = SwiftDataContextManager()
    var container: ModelContainer?
    var context: ModelContext?

    init() {
        do {
            let schema = Schema([Item.self, TopicEntity.self, PhraseCardEntity.self])
            container = try ModelContainer(for: schema)
            if let container {
                context = ModelContext(container)
            }
        } catch {
            debugPrint("Error initializing database container:", error)
        }
    }
}
