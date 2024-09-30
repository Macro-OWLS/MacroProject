//
//  PhraseCard.swift
//  MacroProject
//
//  Created by Agfi on 30/09/24.
//

import Foundation
import SwiftData

@Model
final class PhraseCard {
    var id: String
    var vocabulary: String
    var phrase: String
    var translation: String
    var category: [Category]
    
    init(id: String, vocabulary: String, phrase: String, translation: String, category: [Category]) {
        self.id = id
        self.vocabulary = vocabulary
        self.phrase = phrase
        self.translation = translation
        self.category = category
    }
}
