//
//  UserLibraryDeck.swift
//  MacroProject
//
//  Created by Agfi on 01/10/24.
//

import Foundation
import SwiftData

@Model
final class UserLibraryDeck {
    var id: String
    var category: Category
    var createdAt: Date
    
    init(id: String, category: Category, createdAt: Date) {
        self.id = id
        self.category = category
        self.createdAt = createdAt
    }
}
