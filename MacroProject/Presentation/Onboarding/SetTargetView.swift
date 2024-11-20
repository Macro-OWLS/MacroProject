//
//  SetTargetView.swift
//  MacroProject
//
//  Created by Ages on 19/11/24.
//

import SwiftUI

struct SetTargetView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()
            
            VStack (spacing: 32){
                Image("BubbleTarget")
                    .offset(y: 65)
                Image("CapyTarget")
                    .offset(x: -105, y: 45)
                
                HStack (spacing: 28){
                    TextField("Input number", text: $onboardingViewModel.userInputTarget)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .font(.poppinsHeader3)
                        .keyboardType(.numberPad)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.offwhite)
                                .stroke(Color.lightBrown)
                        )
                        .frame(width: 163, height: 56)
                        .background(Color.cream)
                    
                    Text("Vocab / Day")
                        .font(.poppinsHeader3)
                }
                
                Button(action: {
                    Task {
                        await onboardingViewModel.updateUserTarget()
                    }
                    router.popToRoot()
                }) {
                    ZStack{
                        Color.green
                        Text("Enter")
                            .font(.poppinsB1)
                            .foregroundStyle(Color.grey)
                    }

                }
                .frame(width: 225, height: 50)
                .buttonStyle(.plain)
                .cornerRadius(12)
                
                Text("Set your vocabulary goals at your own pace. Don’t worry, you can \n change the target later!")
                    .font(.poppinsB1)
                    .frame(width: 307)
                    .lineLimit(3) // Restrict to 3 lines
                    .multilineTextAlignment(.center) // Align text in the center
                    
                    
            }
            .onAppear{
                Task {
                    await onboardingViewModel.getUser()
                }
            }
            .navigationBarBackButtonHidden(true)
            .padding(.bottom, 150)
        }
        
    }
}

struct SetTargetView_Previews: PreviewProvider {
    
    static var previews: some View {
        SetTargetView()
            .environmentObject(HomeViewModel())
            
    }
}
