//
//  CreatePhraseCardView.swift
//  MacroProject
//
//  Created by Agfi on 08/10/24.
//

import SwiftUI

struct CreatePhraseCardView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: PhraseCardViewModel
    
    @State private var vocabulary: String = ""
    @State private var phrase: String = ""
    @State private var translation: String = ""
    @State private var isReviewPhase = false
    @State private var boxNumber: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Vocabulary")) {
                    TextField("Vocabulary", text: $vocabulary)
                }
                
                Section(header: Text("Phrase")) {
                    TextField("Phrase", text: $phrase)
                }
                
                Section(header: Text("Translation")) {
                    TextField("Translation", text: $translation)
                }
                
                Section(header: Text("Review Details")) {
                    Toggle("Is Review Phase?", isOn: $isReviewPhase)
                    TextField("Box Number", text: $boxNumber)
                }
                
                Button("Save") {
                    let newPhraseCard = PhraseCardModel(
                        id: UUID().uuidString,
                        topicID: "someTopicID",  // Replace with the actual topic ID
                        vocabulary: vocabulary,
                        phrase: phrase,
                        translation: translation,
                        isReviewPhase: isReviewPhase,
                        levelNumber: boxNumber
                    )
                    viewModel.createPhraseCard(param: newPhraseCard)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Create Phrase Card")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
