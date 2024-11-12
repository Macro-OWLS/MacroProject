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
                .font(.poppinsH2)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.black)

            Text("Add topic from library")
                .font(.poppinsB1)
            .multilineTextAlignment(.center)
            .foregroundColor(Color.black)
            .frame(width: 141, alignment: .top)


        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .frame(width: 173, height: 191, alignment: .center)
        .background(Color.lightBrown)
        .cornerRadius(30)
    }
}

#Preview {
    AddTopic()
}
