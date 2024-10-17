//
//  UserAnswerDTO.swift
//  MacroProject
//
//  Created by Agfi on 17/10/24.
//

import Foundation

struct UserAnswerDTO {
    var id: String
    var topicID: String
    var vocabulary: String
    var phrase: String
    var translation: String
    var isReviewPhase: Bool
    var levelNumber: String
    var lastReviewedDate: Date?
    var nextReviewDate: Date?
    
    var isCorrect: Bool
    var isReviewed: Bool
    var userAnswer: String?
    
    init(id: String, topicID: String, vocabulary: String, phrase: String, translation: String, isReviewPhase: Bool, levelNumber: String, lastReviewedDate: Date? = nil, nextReviewDate: Date? = nil, isCorrect: Bool, isReviewed: Bool, userAnswer: String? = nil) {
        self.id = id
        self.topicID = topicID
        self.vocabulary = vocabulary
        self.phrase = phrase
        self.translation = translation
        self.isReviewPhase = isReviewPhase
        self.levelNumber = levelNumber
        self.lastReviewedDate = lastReviewedDate
        self.nextReviewDate = nextReviewDate
        self.isCorrect = isCorrect
        self.isReviewed = isReviewed
        self.userAnswer = userAnswer
    }
}
