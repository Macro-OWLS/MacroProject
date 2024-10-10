//
//  PhraseCardView.swift
//  MacroProject
//
//  Created by Agfi on 08/10/24.
//

import SwiftUI

struct PhraseCardView: View {
    @ObservedObject var viewModel: PhraseCardViewModel
    @State private var showCreatePhraseCard: Bool = false
    
    var body: some View {
        NavigationView {
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
                        }
                        .onDelete(perform: deletePhraseCard)
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Phrase Cards")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                // Present view to add new phrase card
                                // This could be a navigation to a form for creating new phrase card
                                showCreatePhraseCard.toggle()
                            }) {
                                Image(systemName: "plus")
                            }
                            .sheet(isPresented: $showCreatePhraseCard, content: {
                                CreatePhraseCardView(viewModel: viewModel)
                            })
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchPhraseCards()
            }
        }
    }
    
    private func deletePhraseCard(at offsets: IndexSet) {
        offsets.forEach { index in
            let phraseCard = viewModel.phraseCards[index]
            viewModel.deletePhraseCard(topicId: phraseCard.id)
        }
    }
}

struct PhraseCardRow: View {
    let phraseCard: PhraseCardModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(phraseCard.vocabulary)
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
