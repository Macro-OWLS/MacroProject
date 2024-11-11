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
            
            VStack (spacing: 24){
                VStack (spacing: 8){
                    Text(alert.title)
                        .font(.poppinsHd)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(width: 244, height: 28, alignment: .top)
                    
                    Text(alert.message)
                        .font(.poppinsB1)
                        .multilineTextAlignment(.center)
                        .frame(width: 194, height: 52, alignment: .top)
                }
                    Button(action: {
                        alert.dismissAction()
                        alert.isPresented = false
                    }) {
                        Text("Okay")
                            .font(.poppinsHeader3)
                            .foregroundColor(.white)
                    }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .frame(width: 183, alignment: .center)
                        .background(Color.green)
                        .cornerRadius(12)
            }
        }
        .frame(width: 292, height: 215)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
}

#Preview {
    AlertView(alert: AlertType(isPresented: .constant(true), title: "Daily Review Limit", message: "Cards can only be reviewed", dismissAction: {
        
    }))
}
