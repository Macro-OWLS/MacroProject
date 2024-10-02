//
//  TopicModel.swift
//  MacroProject
//
//  Created by Agfi on 01/10/24.
//

import Foundation

internal struct TopicModel: Equatable, Identifiable {
    var id: String
    var name: String
    var desc: String
    var isAddedToLibraryDeck: Bool
    var phraseCards: [PhraseCardModel]
}
