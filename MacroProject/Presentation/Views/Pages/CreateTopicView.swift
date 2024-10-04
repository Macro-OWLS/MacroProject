//
//  CreateTopicView.swift
//  MacroProject
//
//  Created by Agfi on 04/10/24.
//

import SwiftUI

struct CreateTopicView: View {
    @StateObject var viewModel: TopicViewModel
    
    @State private var topicName: String = ""
    @State private var topicDesc: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Topic Details")) {
                    TextField("Topic Name", text: $topicName)
                    TextField("Description", text: $topicDesc)
                }

                Button(action: {
                    viewModel.createTopic(name: topicName, desc: topicDesc)
                }) {
                    Text("Create Topic")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(topicName.isEmpty || topicDesc.isEmpty)
            }
            .navigationTitle("Create New Topic")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onReceive(viewModel.$isTopicCreated) { isCreated in
            if isCreated {
                dismiss()
            }
        }
        .onDisappear {
            viewModel.isTopicCreated = false
        }
    }
}
