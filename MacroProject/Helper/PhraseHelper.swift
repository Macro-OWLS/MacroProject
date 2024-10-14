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
}
