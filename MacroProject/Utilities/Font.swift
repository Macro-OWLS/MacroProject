//
//  Font.swift
//  MacroProject
//
//  Created by Agfi on 09/10/24.
//


import SwiftUI

struct DefaultFontModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("HelveticaNeue", size: 16))
    }
}

extension View {
    func defaultFont() -> some View {
        self.modifier(DefaultFontModifier())
    }
}
