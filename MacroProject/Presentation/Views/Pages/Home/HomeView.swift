//
//  HomeView.swift
//  MacroProject
//
//  Created by Agfi on 04/11/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color(Color.cream)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: true) {
                VStack(alignment: .leading, spacing: 24) {
                    HomeHeaderContainer()
                    HomeFeatureContainer()
                        .cornerRadius(48, corners: [.topLeft, .topRight])
                }
            }
            .padding(.top, 70)
        }
        .ignoresSafeArea()
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
