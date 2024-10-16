//
//  TopicHelper.swift
//  MacroProject
//
//  Created by Ages on 15/10/24.
//
import Foundation

final class TopicHelper {
    static func filterTopicsByName(by searchTopic: String, from topics: [TopicModel]) -> [TopicModel] {
        guard !searchTopic.isEmpty else {return topics}
        return topics.filter { $0.name.localizedStandardContains(searchTopic) }
    }

     static func filterTopicsById(from topics: [TopicModel], ids: [String]) -> [TopicModel] {
         return topics.filter { ids.contains($0.id) }
     }
}
