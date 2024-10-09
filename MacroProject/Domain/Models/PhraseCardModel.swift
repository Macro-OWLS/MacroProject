//
//  PhraseCardModel.swift
//  MacroProject
//
//  Created by Agfi on 01/10/24.
//

import Foundation

internal struct PhraseCardModel: Equatable, Identifiable ,Decodable {
    var id: String
    var topicID: String
    var vocabulary: String
    var phrase: String
    var translation: String
    var isReviewPhase: Bool
    var boxNumber: String
    var lastReviewedDate: Date?
    var nextReviewDate: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id = "phraseID"
        case topicID = "topicID"
        case vocabulary = "vocabulary"
        case phrase = "phrase"
        case translation = "translation"
        case isReviewPhase = "isReviewPhase"
        case boxNumber = "boxNumber"
    }
}
