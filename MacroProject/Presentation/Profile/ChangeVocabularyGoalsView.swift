//
//  ChangeVocabularyGoalsView.swift
//  MacroProject
//
//  Created by Agfi on 19/11/24.
//

import SwiftUI

struct ChangeVocabularyGoalsView: View {
    @EnvironmentObject var router: Router
    var body: some View {
        ZStack(alignment: .center, content: {
            Color.cream
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 32, content: {
                VocabularyGoalsInput(goalType: .currentGoals)
                VocabularyGoalsInput(goalType: .newGoals)
                
                VStack(alignment: .center, spacing: 16, content: {
                    Button(action: {
                        
                    }) {
                        Text("Change")
                            .font(.poppinsHeader3)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .frame(width: 225, alignment: .center)
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    
                    HStack(alignment: .center, spacing: 2, content: {
                        Text("You can adjust after")
                        Text("167 : 58 : 30")
                            .foregroundColor(.red)
                        Text("Hours")
                    })
                    .font(.poppinsB2)
                })
                .padding(.top, 32)
            })
            .padding(.horizontal, 40)
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    router.navigateBack()
                }) {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                        Text("Back")
                            .font(.poppinsB1)
                    }
                }
                .foregroundColor(.red)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Change Vocalabulary Goals")
    }
}

#Preview {
    ChangeVocabularyGoalsView()
}
