//
//  ReviewCard.swift
//  MacroProject
//
//  Created by Agfi on 08/11/24.
//

import SwiftUI

struct ReviewCard: View {
    let level: Level
    let foregroundColor: Color
    let backgroundColor: Color
    let isCurrentDay: Bool
    let onTap: () -> Void
    @State private var isTapped = false
    @State private var isImageTapped = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            if level.level % 2 == 0 {
                Image("CapybaraRecapLeft")
                    .scaleEffect(isImageTapped ? 0.9 : 1.0)
                    .rotationEffect(isImageTapped ? .degrees(10) : .degrees(0))
                    .offset(x: isImageTapped ? -5 : 0)
                    .opacity(isCurrentDay ? 1.0 : 0.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.4, blendDuration: 0), value: isImageTapped)
                    .onTapGesture {
                        withAnimation {
                            isImageTapped = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            isImageTapped = false
                        }
                    }
            }
            
            HStack(alignment: .center, spacing: 0, content: {
                Image(isCurrentDay ? "PhaseDoor" : "PhaseDoorGrey")
                    .padding([.trailing], 16)
                VStack(alignment: .leading, spacing: 0, content: {
                    Text(level.title)
                        .font(.poppinsHd)
                        .frame(width: 186, alignment: .leading)
                    Text(level.description)
                        .frame(width: 186, alignment: .leading)
                        .font(.poppinsB1)
                })
                Image(systemName: "chevron.right")
            })
            .foregroundColor(isCurrentDay ? .white : .grey)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(isCurrentDay ? Color.green : Color.gray)
            .cornerRadius(16)
            .scaleEffect(isTapped ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: isTapped)
            .onTapGesture {
                withAnimation {
                    isTapped = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    onTap()
                    isTapped = false
                }
            }
            
            if level.level % 2 != 0 {
                Image("CapybaraRecapLeft")
                    .scaleEffect(isImageTapped ? 0.9 : 1.0)
                    .rotationEffect(isImageTapped ? .degrees(-10) : .degrees(0))
                    .offset(x: isImageTapped ? 5 : 0)
                    .opacity(isCurrentDay ? 1.0 : 0.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.4, blendDuration: 0), value: isImageTapped)
                    .onTapGesture {
                        withAnimation {
                            isImageTapped = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            isImageTapped = false
                        }
                    }
            }
        }
    }
}
