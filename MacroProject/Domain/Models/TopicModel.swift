//
//  TopicModel.swift
//  MacroProject
//
//  Created by Agfi on 01/10/24.
//

import Foundation

internal struct TopicModel: Equatable, Identifiable, Decodable, Hashable {
    var id: String
    var name: String
    var icon: String
    var desc: String
    var isAddedToLibraryDeck: Bool
    var section: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "topicID"
        case name = "topicName"
        case icon = "topicicon"
        case desc = "topicDesc"
        case isAddedToLibraryDeck = "isAddedToReview"
        case section = "topicSection"
    }
}
