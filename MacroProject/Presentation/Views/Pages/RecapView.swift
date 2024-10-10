//
//  RecapView.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 10/10/24.
//

import SwiftUI

struct RecapView: View {
    var body: some View {
        VStack {
            ZStack{
                Text("Well Done!")
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .frame(width: 102, height: 30)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(red: 0.36, green: 0.36, blue: 0.36))
            .cornerRadius(10)
            
            HStack(alignment: .top, spacing: 12) {
                Text("2")
                    .font(.system(size: 64))
                    .bold()
                    .foregroundColor(.black)
                    .offset(y: -10)  // Adjust this value to align the top of "2" with "Correct answers"
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Correct answers")
                        .font(.system(size: 28))
                        .bold()
                        .kerning(0.38)
                        .foregroundColor(.black)
                    
                    Text("Move to Level 3")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.55))
                }
                .padding(.bottom, 48)
            }
            .padding(0)
            .frame(width: 291, alignment: .leading)


            HStack(alignment: .top, spacing: 12) {
                Text("0")
                    .font(.system(size: 64))
                    .bold()
                    .foregroundColor(.black)
                    .offset(y: -10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Incorrect answers")
                        .font(.system(size: 28))
                        .bold()
                        .kerning(0.38)
                        .foregroundColor(.black)
                        .frame(alignment: .topLeading)
                    
                    Text("Return to Level 1")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.55))
                        .frame(alignment: .topLeading)
                }
            }
            .padding(0)
            .frame(width: 291, alignment: .leading)


        }
    }
}

#Preview {
    RecapView()
}
