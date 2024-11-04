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
        .init(backgroundColor: Color.red, icon: "ReviewCardMascot", title: "Review Time", description: "Boost memory with every review"),
        .init(backgroundColor: Color.blue, icon: "TopicLibraryMascot", title: "Topic Library", description: "Text Description"),
        .init(backgroundColor: Color.yellow, icon: "MethodTutorialMascot", title: "Method Explanation", description: "Text Description")
    ]
}
