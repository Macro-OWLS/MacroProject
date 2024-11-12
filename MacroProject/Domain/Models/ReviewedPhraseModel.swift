//
//  ReviewedPhrase.swift
//  MacroProject
//
//  Created by Agfi on 29/10/24.
//

import SwiftData
import Foundation
import Combine

internal struct ReviewedPhraseModel: Equatable, Identifiable, Decodable, Hashable {
    var id: String
    var phraseID: String
    var topicID: String
    var vocabulary: String
    var phrase: String
    var translation: String
    var prevLevel: String
    var nextLevel: String
    var lastReviewedDate: Date?
    var nextReviewDate: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case phraseID = "phraseID"
        case topicID = "topicID"
        case vocabulary = "vocabulary"
        case phrase = "phrase"
        case translation = "translation"
        case prevLevel = "prevLevel"
        case nextLevel = "nextLevel"
        case lastReviewedDate = "lastReviewedDate"
        case nextReviewDate = "nextReviewDate"
    }
}
