//
//  Category.swift
//  MacroProject
//
//  Created by Agfi on 30/09/24.
//

import Foundation
import SwiftData

@Model
final class TopicEntity {
    var id: String
    var name: String
    var desc: String
    var isAddedToLibraryDeck: Bool
    
    init(id: String, name: String, desc: String, isAddedToLibraryDeck: Bool) {
        self.id = id
        self.name = name
        self.desc = desc
        self.isAddedToLibraryDeck = isAddedToLibraryDeck
    }
    
    func toDomain() -> TopicModel {
        return .init(
            id: self.id,
            name: self.name,
            desc: self.desc,
            isAddedToLibraryDeck: self.isAddedToLibraryDeck
        )
    }
}
