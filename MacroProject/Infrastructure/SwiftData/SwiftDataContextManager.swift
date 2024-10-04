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
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let storeURL = documentsURL.appendingPathComponent("MacroProject.sqlite")
            
            let configuration = ModelConfiguration(url: storeURL)
            container = try ModelContainer(for: schema, configurations: [configuration])
            
            if let container {
                context = ModelContext(container)
            }
        } catch {
            debugPrint("Error initializing database container:", error)
        }
    }
}
