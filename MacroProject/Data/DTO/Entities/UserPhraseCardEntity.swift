//
//  UserPhraseCardEntity.swift
//  MacroProject
//
//  Created by Agfi on 07/11/24.
//

import Foundation
import SwiftData

@Model
final class UserPhraseCardEntity {
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
    
    init(id: String, profileID: String, phraseID: String, topicID: String, vocabulary: String, phrase: String, translation: String, prevLevel: String, nextLevel: String, lastReviewedDate: Date? = nil, nextReviewDate: Date? = nil, createdAt: Date? = nil) {
        self.id = id
        self.profileID = profileID
        self.phraseID = phraseID
        self.topicID = topicID
        self.vocabulary = vocabulary
        self.phrase = phrase
        self.translation = translation
        self.prevLevel = prevLevel
        self.nextLevel = nextLevel
        self.lastReviewedDate = lastReviewedDate
        self.nextReviewDate = nextReviewDate
        self.createdAt = createdAt
    }
}
