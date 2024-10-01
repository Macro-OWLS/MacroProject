//
//  PhraseCardModel.swift
//  MacroProject
//
//  Created by Agfi on 01/10/24.
//

import Foundation

internal struct PhraseCardModel: Equatable {
    var id: String
    var vocabulary: String
    var phrase: String
    var translation: String
    var topic: TopicModel
    var isReviewPhase: Bool
    var boxNumber: Int
    var status: String
    var lastReviewedDate: Date?
    var nextReviewDate: Date?
}
