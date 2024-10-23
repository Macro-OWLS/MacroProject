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
    var icon: String
    var desc: String
    var isAddedToLibraryDeck: Bool
    var section: String
    
    init(id: String, name: String, icon: String, desc: String, isAddedToLibraryDeck: Bool, section: String) {
        self.id = id
        self.name = name
        self.icon = icon
        self.desc = desc
        self.isAddedToLibraryDeck = isAddedToLibraryDeck
        self.section = section
    }
    
    func toDomain() -> TopicModel {
        return .init(
            id: self.id,
            name: self.name,
            icon: self.icon,
            desc: self.desc,
            isAddedToLibraryDeck: self.isAddedToLibraryDeck,
            section: self.section
        )
    }
}
