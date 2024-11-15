//
//  ConfirmationAlert.swift
//  MacroProject
//
//  Created by Agfi on 15/11/24.
//

import SwiftUI

struct ConfirmationAlert: View {
    var alert: ConfirmationAlertType
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.cream)
                .cornerRadius(30)
            
            VStack (spacing: 24){
                VStack (spacing: 8) {
                    Text(alert.title)
                        .font(.poppinsHd)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(width: 244, height: 28, alignment: .top)
                    
                    Text(alert.message)
                        .font(.poppinsB1)
                        .multilineTextAlignment(.center)
                        .frame(width: 250, height: 22, alignment: .top)
                        .lineLimit(nil)
                }
                
                HStack(alignment: .center, spacing: 24, content: {
                    Button(action: {
                        alert.dismissAction()
                        alert.isPresented = false
                    }) {
                        Text("No")
                            .font(.poppinsHeader3)
                            .foregroundColor(.white)
                    }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .frame(width: 90, alignment: .center)
                        .background(Color.green)
                        .cornerRadius(12)
                    
                    Button(action: {
                        alert.confirmAction()
                        alert.isPresented = false
                    }) {
                        Text("Yes")
                            .font(.poppinsHeader3)
                            .foregroundColor(.red)
                    }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .frame(width: 90, alignment: .center)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .inset(by: 0.5)
                                .stroke(Color.red, lineWidth: 1)
                        )
                })
            }
        }
        .frame(width: 292, height: 176)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
}

#Preview {
    ConfirmationAlert(alert: ConfirmationAlertType(isPresented: .constant(true), title: "Discard Changes?", message: "Your added cards will be lost. Continue?", confirmAction: {
        
    }, dismissAction: {
        
    }))
}
