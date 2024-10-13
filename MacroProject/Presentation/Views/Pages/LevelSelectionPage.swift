//
//  LevelSelectionPage.swift
//  MacroProject
//
//  Created by Agfi on 12/10/24.
//

import SwiftUI

struct LevelSelectionPage: View {
    @StateObject var phraseCardViewModel: PhraseCardViewModel = PhraseCardViewModel()
    
    var level: Level
    var body: some View {
        VStack(content: {
            HStack(alignment: .top, spacing: 16, content: {
                TopicCardReview()
                TopicCardReview()
            })
        })
        .navigationTitle(level.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
