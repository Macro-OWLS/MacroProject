//
//  CustomTabItem.swift
//  MacroProject
//
//  Created by Agfi on 12/10/24.
//

import SwiftUI

struct CustomTabItem: View {
    let label: String
    let systemImage: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: systemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
            
            Text(label)
                .font(.system(size: 14, weight: .bold))
        }
        .foregroundColor(isSelected ? Color.turquoise : Color.black)
        .padding(.vertical, 8)
    }
}

#Preview {
    ContentView()
}
