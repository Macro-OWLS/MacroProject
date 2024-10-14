//
//  PhraseCardView.swift
//  MacroProject
//
//  Created by Agfi on 08/10/24.
//

import SwiftUI
import Routing

struct LibraryPhraseCardView: View {
    @ObservedObject var viewModel: PhraseCardViewModel
    @StateObject var router: Router<NavigationRoute>
//    @State private var showCreatePhraseCard: Bool = false
    let topicID: String
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                List {
                    ForEach(viewModel.phraseCards) { phraseCard in
                        PhraseCardRow(phraseCard: phraseCard)
                            .onTapGesture {
                                viewModel.updatePhraseCards(phraseID: phraseCard.id)
                            }
                            
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Phrase Cards")
//        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.fetchPhraseCards(topicID: topicID)
        }
    }
}

struct PhraseCardRow: View {
    let phraseCard: PhraseCardModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("levelNumber:\(phraseCard.levelNumber) isReviewPhase:\(phraseCard.isReviewPhase)")
                .font(.headline)
            Text(phraseCard.phrase)
                .font(.subheadline)
            Text("Translation: \(phraseCard.translation)")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
