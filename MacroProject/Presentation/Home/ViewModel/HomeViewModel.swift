//
//  HomeViewModel.swift
//  MacroProject
//
//  Created by Agfi on 04/11/24.
//

import Foundation
import Combine
import SwiftUI

internal final class HomeViewModel: ObservableObject {
    @Published var featureCards: [FeatureCardType] = [
        .init(id: "review", backgroundColor: Color.red, icon: "ReviewCardMascot", title: "Review Time", description: "Boost memory with every review"),
        .init(id: "study", backgroundColor: Color.blue, icon: "TopicStudyMascot", title: "Topic Study", description: "Text Description"),
        .init(id: "tutorial", backgroundColor: Color.yellow, icon: "MethodTutorialMascot", title: "Method Explanation", description: "Text Description")
    ]
}
