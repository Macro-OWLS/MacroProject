//
//  ReviewBox.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 01/10/24.
//

import SwiftUI

struct ReviewBox: View {
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
              .fill(.quaternary)

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("level 1")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Learn this everyday")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                        .frame(maxWidth: 305, alignment: .leading)
                }
                
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .bold))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .frame(width: 360, height: 96, alignment: .leading)
    }
}

#Preview {
    ReviewBox()
}

