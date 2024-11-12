//
//  AddCard.swift
//  MacroProject
//
//  Created by Ages on 12/11/24.
//
import SwiftUI

struct AddCard: View {
    var isDisabled: Bool
    
    var body: some View {
        if isDisabled {
            ZStack{
                Color.gray
                Text("Add Cards")
                    .font(.poppinsB1)
                    .foregroundStyle(Color.grey)
            }
            .cornerRadius(12)
        } else {
            ZStack{
                Color.green
                Text("Add Cards")
                    .font(.poppinsB1)
                    .foregroundStyle(Color.white)
            }
            .cornerRadius(12)
        }

    }
}
