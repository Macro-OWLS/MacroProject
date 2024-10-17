//
//  PhraseFilter.swift
//  MacroProject
//
//  Created by Ages on 14/10/24.
//

import Foundation

enum VocabEdit {
    case bold
    case blank
    case userAnswer
//    case replace
}

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

    func vocabSearch(phrase: String, vocab: String, vocabEdit: VocabEdit, userInput: String?, isRevealed: Bool) -> String {
        switch vocabEdit {
        case .bold:
            return phrase.replacingOccurrences(of: vocab, with: "**\(vocab)**" )
        case .blank:
            if (userInput != nil && isRevealed) {
                return phrase.replacingOccurrences(of: vocab, with: userInput! )
            } else {
                return phrase.replacingOccurrences(of: vocab, with: "_____" )
            }
        case .userAnswer:
            return phrase.replacingOccurrences(of: vocab, with: "**\(userInput ?? "Kosong")**" )
//        case .replace:
//            return phrase.replacingOccurrences(of: vocab, with: "" )
        }

    }
}


