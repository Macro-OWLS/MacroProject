//
//  ReviewedPhraseEntity.swift
//  MacroProject
//
//  Created by Agfi on 29/10/24.
//

import SwiftData
import Foundation
import Combine

@Model
final class ReviewedPhraseEntity {
    var id: String
    var phraseID: String
    var topicID: String
    var vocabulary: String
    var phrase: String
    var translation: String
    var prevLevel: String
    var nextLevel: String
    var lastReviewedDate: Date
    var nextReviewDate: Date
    
    init(id: String, phraseID: String, topicID: String, vocabulary: String, phrase: String, translation: String, prevLevel: String, nextLevel: String, lastReviewedDate: Date, nextReviewDate: Date) {
        self.id = id
        self.phraseID = phraseID
        self.topicID = topicID
        self.vocabulary = vocabulary
        self.phrase = phrase
        self.translation = translation
        self.prevLevel = prevLevel
        self.nextLevel = nextLevel
        self.lastReviewedDate = lastReviewedDate
        self.nextReviewDate = nextReviewDate
    }
    
    func toDomain() -> ReviewedPhraseModel {
        return .init(
            id: self.id,
            phraseID: self.phraseID,
            topicID: self.topicID,
            vocabulary: self.vocabulary,
            phrase: self.phrase,
            translation: self.translation,
            prevLevel: self.prevLevel,
            nextLevel: self.nextLevel,
            lastReviewedDate: self.lastReviewedDate,
            nextReviewDate: self.nextReviewDate
        )
    }
}
