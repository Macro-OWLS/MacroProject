//
//  PhraseCardModel.swift
//  MacroProject
//
//  Created by Agfi on 01/10/24.
//

import Foundation

internal struct PhraseCardModel: Equatable, Identifiable, Decodable, Hashable {
    var id: String
    var topicID: String
    var vocabulary: String
    var phrase: String
    var translation: String
    var isReviewPhase: Bool
    var levelNumber: String
    var prevLevel: String?
    var nextLevel: String?
    var lastReviewedDate: Date?
    var nextReviewDate: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id = "phraseID"
        case topicID = "topicID"
        case vocabulary = "vocabulary"
        case phrase = "phrase"
        case translation = "translation"
        case isReviewPhase = "isReviewPhase"
        case levelNumber = "levelNumber"
        case prevLevel = "prevlevel"
        case nextLevel = "nextlevel"
        case lastReviewedDate = "lastReviewedDate"
        case nextReviewDate = "nextReviewDate"
    }
}
