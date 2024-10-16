//
//  TopicHelper.swift
//  MacroProject
//
//  Created by Ages on 15/10/24.
//
import Foundation

final class TopicHelper {
    static func filterTopics(by searchTopic: String, from topics: [TopicModel]) -> [TopicModel] {
        guard !searchTopic.isEmpty else {return topics}
        return topics.filter { $0.name.localizedStandardContains(searchTopic) }
    }
}
