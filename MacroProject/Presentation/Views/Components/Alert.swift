//
//  Alert.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 07/10/24.
//

import SwiftUI

struct AlertView: View {
    var alert: AlertType
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.cream)
            
            VStack (spacing: 24){
                VStack (spacing: 4){
                    Text(alert.title)
                        .font(.helveticaHeadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(width: 244, height: 28, alignment: .top)
                    
                    Text(alert.message)
                        .font(.helveticaBody1)
                        .multilineTextAlignment(.center)
                        .frame(width: 194, height: 44, alignment: .top)
                }
                    Button(action: {
                        alert.dismissAction()
                        alert.isPresented = false
                    }) {
                        Text("Okay")
                            .font(.helveticaHeader3)
                            .foregroundColor(.white)
                    }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .frame(width: 125, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .inset(by: 0.5)
                                .stroke(Constants.GraysBlack, lineWidth: 1))
            }
        }
        .background(
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
        )
        .frame(width: 292, height: 198)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)

    }
}

//#Preview {
//    ContentView()
//}
