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

}

enum PhraseFilterBy: String {
    case id
    case topic
    case level
}

enum reviewedPhraseFilterBy: String {
    case phrase
    case topic
    case prevLevel
    case nextLevel
}

enum DateType: String {
    case lastDate
    case nextDate
}

final class PhraseHelper {
    static func filterPhrases(using filters: [(PhraseFilterBy, String)], dateFilters: [(DateType, Date?)]? = nil, from phrases: [PhraseCardModel]) -> [PhraseCardModel] {
        return phrases.filter { phrase in
            var isMatch = true
            
            for (filter, value) in filters {
                switch filter {
                case .id:
                    if phrase.id != value {
                        isMatch = false
                    }
                case .topic:
                    if phrase.topicID != value {
                        isMatch = false
                    }
                case .level:
                    if phrase.prevLevel != value && phrase.nextLevel != value {
                        isMatch = false
                    }
                }
                if !isMatch { break }
            }

            
            if let dateFilters = dateFilters {
                for (dateType, dateValue) in dateFilters {
                    switch dateType {
                    case .lastDate:
                        if let dateValue = dateValue {
                            if DateHelper.formattedDateString(from: phrase.lastReviewedDate) != DateHelper.formattedDateString(from: dateValue) {
                                isMatch = false
                            }
                        }
                    case .nextDate:
                        if let dateValue = dateValue {
                            if DateHelper.formattedDateString(from: phrase.nextReviewDate) != DateHelper.formattedDateString(from: dateValue) {
                                isMatch = false
                            }
                        }
                    }

                    if !isMatch { break }
                }
            }

            return isMatch
        }
    }
    
    static func filterReviewedPhrases(
        using filters: [(reviewedPhraseFilterBy, String)]? = nil,
        dateFilters: [(DateType, Date?)]? = nil,
        from phrases: [ReviewedPhraseModel]
    ) -> [ReviewedPhraseModel] {
        
        return phrases.filter { phrase in
            var isMatch = true
            
            if let filters = filters {
                for (filter, value) in filters {
                    switch filter {
                    case .phrase:
                        if phrase.phraseID != value {
                            isMatch = false
                        }
                    case .topic:
                        if phrase.topicID != value {
                            isMatch = false
                        }
                    case .prevLevel:
                        if phrase.prevLevel != value {
                            isMatch = false
                        }
                    case .nextLevel:
                        if phrase.nextLevel != value {
                            isMatch = false
                        }
                    }
                    if !isMatch { break }
                }
            }
            
            if let dateFilters = dateFilters {
                for (dateType, dateValue) in dateFilters {
                    switch dateType {
                    case .lastDate:
                        if let dateValue = dateValue,
                           DateHelper.formattedDateString(from: phrase.lastReviewedDate) != DateHelper.formattedDateString(from: dateValue) {
                            isMatch = false
                        }
                    case .nextDate:
                        if let dateValue = dateValue,
                           DateHelper.formattedDateString(from: phrase.nextReviewDate) != DateHelper.formattedDateString(from: dateValue) {
                            isMatch = false
                        }
                    }
                    if !isMatch { break }
                }
            }

            return isMatch
        }
    }


    func vocabSearch(phrase: String, vocab: String, vocabEdit: VocabEdit, userInput: String?, isRevealed: Bool) -> String {
        var lowercasedPhrase = phrase.lowercased()
        var lowercasedVocab = vocab.lowercased()
        
        switch vocabEdit {
        case .bold:
            if lowercasedPhrase.contains(lowercasedVocab) {
                return lowercasedPhrase.replacingOccurrences(of: lowercasedVocab, with: "**\(vocab)**")
            } else {
                print("Vocab not found in phrase (\(lowercasedVocab)): \(lowercasedPhrase)")
                return lowercasedPhrase
            }
        case .blank:
            if let userInput = userInput, isRevealed {
                return lowercasedPhrase.replacingOccurrences(of: lowercasedVocab, with: userInput)
            } else {
                return lowercasedPhrase.replacingOccurrences(of: lowercasedVocab, with: "_____")
            }
        case .userAnswer:
            return phrase.replacingOccurrences(of: lowercasedVocab, with: "**\(userInput ?? "Kosong")**")
        }
    }
}
