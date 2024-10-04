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
    var phraseCards: [PhraseCardEntity]
    
    // Updated init to include phraseCards
    init(id: String, name: String, desc: String, isAddedToLibraryDeck: Bool, phraseCards: [PhraseCardEntity] = []) {
        self.id = id
        self.name = name
        self.desc = desc
        self.isAddedToLibraryDeck = isAddedToLibraryDeck
        self.phraseCards = phraseCards
    }
    
    func toDomain() -> TopicModel {
        return .init(
            id: self.id,
            name: self.name,
            desc: self.desc,
            isAddedToLibraryDeck: self.isAddedToLibraryDeck,
            phraseCards: self.phraseCards.map { $0.toDomain() }
        )
    }
}
