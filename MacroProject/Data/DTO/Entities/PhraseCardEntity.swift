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
    var phraseID: String
    var topicID: String
    var vocabulary: String
    var phrase: String
    var translation: String
    //var topic: TopicEntity
    var isReviewPhase: Bool
    var boxNumber: String
    //var status: String
    var lastReviewedDate: Date?
    var nextReviewDate: Date?
    
    init(phraseID: String, topicID: String, vocabulary: String, phrase: String, translation: String, isReviewPhase: Bool, boxNumber: String, lastReviewedDate: Date?, nextReviewDate: Date?) {
        self.phraseID = phraseID
        self.topicID = topicID
        self.vocabulary = vocabulary
        self.phrase = phrase
        self.translation = translation
        //self.topic = topic
        self.isReviewPhase = isReviewPhase
        self.boxNumber = boxNumber
        //self.status = status
        self.lastReviewedDate = lastReviewedDate
        self.nextReviewDate = nextReviewDate
    }
    
    func toDomain() -> PhraseCardModel {
        return .init(
            id: self.phraseID,
            topicID: self.topicID,
            vocabulary: self.vocabulary,
            phrase: self.phrase,
            translation: self.translation,
            //topic: self.topic.toDomain(),
            isReviewPhase: self.isReviewPhase,
            boxNumber: self.boxNumber
            //status: self.status
        )
    }
}
