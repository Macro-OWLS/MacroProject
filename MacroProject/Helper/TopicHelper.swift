//
//  TopicHelper.swift
//  MacroProject
//
//  Created by Agfi on 15/10/24.
//

import Foundation

final class TopicHelper {
    static func filterTopicsById(from topics: [TopicModel], ids: [String]) -> [TopicModel] {
        return topics.filter { ids.contains($0.id) }
    }
}
