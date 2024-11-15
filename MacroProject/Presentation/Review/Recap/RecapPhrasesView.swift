//
//  ReviewRecapView.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 11/10/24.
//

import SwiftUI

struct RecapPhrasesView: View {
    @EnvironmentObject var reviewPhraseViewModel: ReviewPhraseViewModel
    @EnvironmentObject var router: Router

    var body: some View {
        ZStack(alignment: .top) {
            // Set the background color to cream
            Color.cream
                .ignoresSafeArea() // Ensure it covers the entire screen
            
            VStack (spacing: 5){
                ScrollView(content: {
                    ForEach(reviewPhraseViewModel.recapAnsweredPhraseCards, id: \.self) { phrase in
                        VStack {
                            if phrase.isCorrect {
                                CorrectPhrasePreview(phrase: phrase)
                            } else {
                                IncorrectPhrasePreview(phrase: phrase)
                                    .padding(.vertical, 30)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .padding(.top, 10)
                })
                .edgesIgnoringSafeArea(.bottom)
            }
            .padding(.horizontal)
            .navigationTitle("Review Recap")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) // Hide the default back button
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        router.navigateBack()
                    }) {
                        HStack(alignment: .center, spacing: 4, content: {
                            Image(systemName: "chevron.left")
                                .fontWeight(.semibold)
                            Text("Back")
                                .font(.poppinsB1)
                        })
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
    
}


#Preview {
    RecapPhrasesView()
        .environmentObject(ReviewPhraseViewModel())
}
