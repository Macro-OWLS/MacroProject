//
//  AddTopic.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 07/10/24.
//

import SwiftUI

struct AddTopic: View {
    var body: some View {
        VStack {
            Image(systemName: "plus")
                .font(.system(size: 36))
                .bold()
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            Text("Add topic from library")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                .padding(.top, 16)


        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .frame(width: 173, height: 164, alignment: .center)
        .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.35))
        .cornerRadius(30)
    }
}

#Preview {
    AddTopic()
}
