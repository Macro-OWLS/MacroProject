//
//  VocabularyGoalsInput.swift
//  MacroProject
//
//  Created by Agfi on 19/11/24.
//

import SwiftUI

enum GoalType {
    case currentGoals
    case newGoals
}

struct VocabularyGoalsInput: View {
    var goalType: GoalType
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Your \(goalType == .currentGoals ? "Current" : "New") Goals")
                .font(.poppinsB2)
            HStack(alignment: .center, spacing: 0, content: {
                if goalType == .currentGoals {
                    Text("15")
                        .font(.poppinsH3)
                        .foregroundColor(goalType == .currentGoals ? .white : .black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .frame(minWidth: 163, alignment: .leading)
                        .background(goalType == .currentGoals ? Color.darkGrey : .white)
                        .cornerRadius(12)
                } else {
                    TextField("", text: .constant("15"))
                        .font(.poppinsH3)
                        .foregroundColor(goalType == .currentGoals ? .white : .black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .frame(maxWidth: 163, alignment: .leading)
                        .background(goalType == .currentGoals ? Color.darkGrey : .white)
                        .cornerRadius(12)
                }
                Spacer()
                Text("Vocab / Day")
            })
        }
    }
}
