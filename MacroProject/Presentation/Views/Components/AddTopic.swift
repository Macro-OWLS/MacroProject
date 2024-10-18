//
//  AddTopic.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 07/10/24.
//

import SwiftUI

struct AddTopic: View {
    var body: some View {
        VStack (alignment: .center, spacing: 16){
            Image(systemName: "plus")
                .font(.helveticaHeader2)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.grey)
            
            Text("Add topic from library")
                .font(.helveticaBody1)
            .multilineTextAlignment(.center)
            .foregroundColor(Color.grey)
            .frame(width: 141, alignment: .top)


        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .frame(width: 173, height: 191, alignment: .center)
        .background(Color.white)
        .cornerRadius(30)
        .overlay(
        RoundedRectangle(cornerRadius: 30)
        .inset(by: 0.5)
        .stroke(Constants.GraysBlack, lineWidth: 1))

    }
}

#Preview {
    AddTopic()
}
