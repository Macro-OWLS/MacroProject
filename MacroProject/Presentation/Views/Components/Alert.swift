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
                .cornerRadius(30)
                .overlay(
                RoundedRectangle(cornerRadius: 30)
                .inset(by: 0.5)
                .stroke(Color.brown, lineWidth: 1)
                )
            
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
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .inset(by: 0.5)
                                .stroke(Color.black, lineWidth: 1))
            }
        }
        .frame(width: 292, height: 198)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
}
