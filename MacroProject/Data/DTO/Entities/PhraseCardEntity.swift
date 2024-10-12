//
//  PhraseCard.swift
//  MacroProject
//
//  Created by Agfi on 30/09/24.
//

import Foundation
import SwiftData

@Model
final class PhraseCardEntity {
    var id: String
    var topicID: String
    var vocabulary: String
    var phrase: String
    var translation: String
    var isReviewPhase: Bool
    var levelNumber: String
    var lastReviewedDate: Date?
    var nextReviewDate: Date?
    
    init(id: String, topicID: String, vocabulary: String, phrase: String, translation: String, isReviewPhase: Bool, levelNumber: String, lastReviewedDate: Date?, nextReviewDate: Date?) {
        self.id = id
        self.topicID = topicID
        self.vocabulary = vocabulary
        self.phrase = phrase
        self.translation = translation
        self.isReviewPhase = isReviewPhase
        self.levelNumber = levelNumber
        self.lastReviewedDate = lastReviewedDate
        self.nextReviewDate = nextReviewDate
    }
    
    func toDomain() -> PhraseCardModel {
        return .init(
            id: self.id,
            topicID: self.topicID,
            vocabulary: self.vocabulary,
            phrase: self.phrase,
            translation: self.translation,
            isReviewPhase: self.isReviewPhase,
            levelNumber: self.levelNumber,
            lastReviewedDate: self.lastReviewedDate,
            nextReviewDate: self.nextReviewDate
        )
    }
}
