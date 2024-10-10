//
//  TopicModel.swift
//  MacroProject
//
//  Created by Agfi on 01/10/24.
//

import Foundation

internal struct TopicModel: Equatable, Identifiable, Decodable {
    var id: String
    var name: String
    var desc: String
    var isAddedToLibraryDeck: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id = "topicID"
        case name = "topicName"
        case desc = "topicDesc"
        case isAddedToLibraryDeck = "isAddedToReview"
    }
}
