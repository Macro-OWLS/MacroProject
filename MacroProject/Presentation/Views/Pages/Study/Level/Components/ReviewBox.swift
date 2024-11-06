//
//  ReviewBox.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 01/10/24.
//

import SwiftUI

struct ReviewBox: View {
    @EnvironmentObject var router: Router
    var level: LevelType
    var color: Color

    var body: some View {
        Button() {
            // navigasi
        } label: {
            HStack (spacing: 16){
                Image(systemName: "brain.fill")
                    .resizable()
                    .foregroundStyle(Color.pink)
                    .scaledToFit()
                    .frame(width: 50, height: 41.46)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(level.level.title)
                        .font(.helveticaHeadline)
                    
                    Text(level.level.description)
                        .font(.helveticaBody1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
            }
            .frame(width: 246, height: 75)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(color)
            .cornerRadius(15)
        }.buttonStyle(.plain)
    }
}

