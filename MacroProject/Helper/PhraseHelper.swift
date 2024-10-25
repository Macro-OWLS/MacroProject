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

enum FilterBy: String {
    case id
    case topic
    case level
}

enum DateType: String {
    case lastDate
    case nextDate
}

final class PhraseHelper {
    static func filterPhrases(using filters: [(FilterBy, String)], dateFilters: [(DateType, Date)]? = nil, from phrases: [PhraseCardModel]) -> [PhraseCardModel] {
        return phrases.filter { phrase in
            for (filter, value) in filters {
                switch filter {
                case .id:
                    if phrase.id != value { return false }
                case .topic:
                    if phrase.topicID != value { return false }
                case .level:
                    if phrase.levelNumber != value { return false }
                }
            }
            
            if let dateFilters = dateFilters {
                for (dateType, dateValue) in dateFilters {
                    switch dateType {
                    case .lastDate:
                        if let lastReviewedDate = phrase.lastReviewedDate, lastReviewedDate != dateValue { return false }
                    case .nextDate:
                        if let nextReviewDate = phrase.nextReviewDate, nextReviewDate != dateValue { return false }
                    }
                }
            }
            
            return true
        }
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


