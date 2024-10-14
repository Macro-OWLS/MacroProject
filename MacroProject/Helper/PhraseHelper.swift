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
}

final class PhraseHelper {
    
    static func filterPhrases(by topicID: String, from phrases: [PhraseCardModel]) -> [PhraseCardModel] {
        return phrases.filter { $0.topicID == topicID }
    }
    
    func vocabSearch(phrase: String, vocab: String, vocabEdit: VocabEdit) -> String {
         
        switch vocabEdit {
        case .bold:
            return phrase.replacingOccurrences(of: vocab, with: "**\(vocab)**" )
        case .blank:
            return phrase.replacingOccurrences(of: vocab, with: "_____" )
        }
       
    }
}


