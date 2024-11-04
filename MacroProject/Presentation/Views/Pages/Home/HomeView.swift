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
            .padding(.top, 16)
        }
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

struct HomeHeaderContainer: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            HStack(alignment: .center, content: {
                Spacer()
                
                HStack(spacing: 8, content: {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("**2** Days Streak")
                    }
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                })
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(Color.darkcream)
                .cornerRadius(8)
            })
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Hi Fahri")
                    .font(.helveticaHeadline)
                Text("Ready to make progress today?")
                    .font(.helveticaBody1)
            }
        })
        .padding(.horizontal, 16)
    }
}
