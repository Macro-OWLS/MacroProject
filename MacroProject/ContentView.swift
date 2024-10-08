//
//  ContentView.swift
//  MacroProject
//
//  Created by Agfi on 17/09/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var topicViewModel: TopicViewModel = TopicViewModel(useCase: TopicUseCase(repository: TopicRepository()))
    
    var body: some View {
        TopicListView(viewModel: topicViewModel)
//            .onAppear {
//                topicViewModel.deletePhrases(id: )
//            }
    }
    
}

#Preview {
    ContentView()
}
