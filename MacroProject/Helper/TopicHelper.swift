//
//  TopicHelper.swift
//  MacroProject
//
//  Created by Ages on 15/10/24.
//
import Foundation

enum TopicFilterBy: String {
    case id
    case name
    case section
}

final class TopicHelper {
    
    // Filters topics based on specified criteria
    static func filterTopics(using filters: [(TopicFilterBy, String)], from topics: [TopicModel]) -> [TopicModel] {
        return topics.filter { topic in
            var isMatch = true
            
            for (filter, value) in filters {
                switch filter {
                case .id:
                    if topic.id != value {
                        isMatch = false
                    }
                case .section:
                    if topic.section != value {
                        isMatch = false
                    }
                case .name:
                    if !topic.name.lowercased().contains(value.lowercased()) {
                        isMatch = false
                    }
                }

                if !isMatch {
                    return false
                }
            }
            return isMatch
        }
    }
    
    // Filters topics by multiple IDs
    static func filterTopicsByMultipleIds(from topics: [TopicModel], ids: [String]) -> [TopicModel] {
        return topics.filter { ids.contains($0.id) }
    }
}
