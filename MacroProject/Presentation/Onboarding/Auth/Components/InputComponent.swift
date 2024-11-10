//
//  InputComponent.swift
//  MacroProject
//
//  Created by Agfi on 10/11/24.
//

import SwiftUI

struct InputComponent: View {
    var input: InputType
    var body: some View {
        VStack(alignment: .leading, spacing: 4, content: {
            Text(input.title)
                .font(.poppinsB1)
            if input.title == "Password" {
                SecureField(input.placeholder, text: input.value)
                    .font(.poppinsB2)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.offwhite)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .inset(by: 0.5)
                            .stroke(Color.lightBrown, lineWidth: 1)
                    )
            } else {
                TextField(input.placeholder, text: input.value)
                    .font(.poppinsB2)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.offwhite)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .inset(by: 0.5)
                            .stroke(Color.lightBrown, lineWidth: 1)
                    )
            }
        })
        .padding(.horizontal, 16)
    }
}
