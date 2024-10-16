//
//  TopicDTO.swift
//  MacroProject
//
//  Created by Agfi on 15/10/24.
//

import Foundation

internal struct TopicDTO: Equatable, Identifiable, Decodable, Hashable {
    var id: String
    var name: String
    var description: String
    var hasReviewedTodayCount: Int
    var phraseCardCount: Int
}
