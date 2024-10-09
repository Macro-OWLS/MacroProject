//
//  Alert.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 07/10/24.
//

import SwiftUI

struct AlertView: View {
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.quaternary)
            
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.secondary)
                }
                .padding(.trailing)
                .padding(.top, 24)
                .padding(.bottom, 8)

                Text("Daily Review Limit")
                    .bold()
                    .font(.system(size: 22))
                    .frame(width: 244, height: 28, alignment: .top)

                Text("Describe symptoms and get advice")
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
                    .frame(width: 194, height: 44, alignment: .top)
                    .padding(.top, 4)
                    .padding(.bottom, 24)
                
            }
        }
        .frame(width: 292, height: 168)
        .padding(.horizontal, 16)
    }
}

#Preview {
    AlertView()
}
