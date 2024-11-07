//
//  UserPhraseCardModel.swift
//  MacroProject
//
//  Created by Agfi on 07/11/24.
//

import Foundation

struct UserPhraseCardModel: Equatable, Identifiable, Decodable, Hashable {
    var id: String
    var profileID: String
    var phraseID: String
    var topicID: String
    var vocabulary: String
    var phrase: String
    var translation: String
    var prevLevel: String
    var nextLevel: String
    var lastReviewedDate: Date?
    var nextReviewDate: Date?
    var createdAt: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case phraseID = "phrase_id"
        case profileID = "profile_id"
        case topicID = "topic_id"
        case vocabulary = "vocabulary"
        case phrase = "phrase"
        case translation = "translation"
        case prevLevel = "prevLevel"
        case nextLevel = "nextLevel"
        case lastReviewedDate = "lastReviewedDate"
        case nextReviewDate = "nextReviewDate"
        case createdAt = "createdAt"
    }
}
