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
    var topicID: String
    var name: String
    var desc: String
    var isAddedToLibraryDeck: Bool
    //var phraseCards: [PhraseCardEntity]
    
    
    // Updated init to include phraseCards
    init(id: String, name: String, desc: String, isAddedToLibraryDeck: Bool) {
        self.topicID = id
        self.name = name
        self.desc = desc
        self.isAddedToLibraryDeck = isAddedToLibraryDeck
        //self.phraseCards = phraseCards
    }
    
    func toDomain() -> TopicModel {
        return .init(
            id: self.topicID,
            name: self.name,
            desc: self.desc,
            isAddedToLibraryDeck: self.isAddedToLibraryDeck
            //phraseCards: self.phraseCards.map { $0.toDomain() }
        )
    }
}
