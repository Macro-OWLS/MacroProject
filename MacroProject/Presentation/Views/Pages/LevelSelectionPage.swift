//
//  LevelSelectionPage.swift
//  MacroProject
//
//  Created by Agfi on 12/10/24.
//

import SwiftUI

struct LevelSelectionPage: View {
    @ObservedObject var levelViewModel: LevelViewModel
    var level: Level
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedView: TabViewType
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                if level.level == 1 {
                    AddTopic()
                        .onTapGesture {
                            selectedView = .library
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                ForEach(levelViewModel.topicsToReviewTodayFilteredByLevel) { topic in
                    TopicCardReview(topicDTO: topic)
                }
            }
            .padding()
            Spacer()
        }
        .navigationTitle(level.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            levelViewModel.fetchTopicsByFilteredPhraseCards(levelNumber: String(level.level), level: level)
        }
        .overlay(
            Group {
                if levelViewModel.showAlert {
                    Color.black.opacity(0.4) // Background dimming effect
                        .edgesIgnoringSafeArea(.all)
                    AlertView(alert: AlertType(isPresented: $levelViewModel.showAlert, title: levelViewModel.alertTitle, message: levelViewModel.alertMessage, dismissAction: {
                        levelViewModel.resetAlert()
                        presentationMode.wrappedValue.dismiss()
                    }))
                }
            }
        )
        .navigationBarBackButtonHidden(levelViewModel.showAlert)
    }
}

#Preview {
    ContentView()
}
