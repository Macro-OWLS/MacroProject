//
//  BubbleChat.swift
//  MacroProject
//
//  Created by Agfi on 10/11/24.
//

import SwiftUI

struct BubbleChat: View {
    var text: String
    var body: some View {
        VStack(alignment: .trailing, spacing: -5) {
            Text(text)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.brown)
                .cornerRadius(15)
                .foregroundColor(.white)
                .font(.poppinsH3)
            Image("Chat")
                .offset(x: -15)
        }
    }
}
