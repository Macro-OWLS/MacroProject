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
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                if level.level == 1 {
                    AddTopic()
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
                    CustomAlertView(
                        isPresented: $levelViewModel.showAlert,
                        title: levelViewModel.alertTitle,
                        message: levelViewModel.alertMessage,
                        dismissAction: {
                            levelViewModel.resetAlert()
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
            }
        )
        .navigationBarBackButtonHidden(levelViewModel.showAlert)
    }
}

#Preview {
    ContentView()
}

struct CustomAlertView: View {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let dismissAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
            Text(message)
                .multilineTextAlignment(.center)
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .padding()
                .background(Color.red.opacity(0.2))
                .cornerRadius(8)
                
                Button("OK") {
                    dismissAction()
                    isPresented = false
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 20)
        .padding()
    }
}
