//
//  PhraseFilter.swift
//  MacroProject
//
//  Created by Ages on 14/10/24.
//

import Foundation

final class PhraseHelper {
    static func filterPhrases(by topicID: String, from phrases: [PhraseCardModel]) -> [PhraseCardModel] {
        return phrases.filter { $0.topicID == topicID }
    }
    
    static func filterPhraseByIdAndLevel(by id: String, levelNumber: String, from phrases: [PhraseCardModel]) -> [PhraseCardModel] {
        return phrases.filter { $0.topicID == id && $0.levelNumber == levelNumber}
    }
    
    static func filterPhraseByLevel(levelNumber: String, from phrases: [PhraseCardModel]) -> [PhraseCardModel] {
        return phrases.filter { $0.levelNumber == levelNumber}
    }
}
