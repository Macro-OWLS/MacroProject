//
//  ChangeVocabularyGoalsView.swift
//  MacroProject
//
//  Created by Agfi on 19/11/24.
//

import SwiftUI

struct ChangeVocabularyGoalsView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack(alignment: .center, content: {
            Color.cream
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 32, content: {
                VocabularyGoalsInput(goalType: .currentGoals, isDisabled: false)
                VocabularyGoalsInput(goalType: .newGoals, isDisabled: onboardingViewModel.isDisabled)
                
                VStack(alignment: .center, spacing: 16, content: {
                    if !onboardingViewModel.showConfirmationAlert {
                        Button(action: {
                            onboardingViewModel.showConfirmationAlert = true
                        }) {
                            ZStack{
                                if onboardingViewModel.isDisabled {
                                    Color.gray
                                } else {
                                    Color.green
                                }

                                Text("Change")
                                    .font(.poppinsHeader3)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 14)
                                    .foregroundColor(onboardingViewModel.isDisabled ? .grey : .white)
                            }
                        }
                        .frame(width: 225, height: 50, alignment: .center)
                        .cornerRadius(12)
                        .disabled(onboardingViewModel.isDisabled)
                        
                    }
                    
                    
                    if onboardingViewModel.cooldownTimeRemaining != 0 {
                        HStack(alignment: .center, spacing: 2, content: {
                            Text("You can adjust after")
                            Text("\(onboardingViewModel.cooldownTimeRemaining)")
                                .foregroundColor(.red)
                            Text(" Days")
                        })
                        .font(.poppinsB2)
                    } else {
                        Text("Attention! You can only change your goals once a week")
                            .multilineTextAlignment(.center)
                    }

                })
                .padding(.top, 32)
            })
            .padding(.horizontal, 40)
            
            if onboardingViewModel.showConfirmationAlert {
                Color.black.opacity(0.4).ignoresSafeArea(edges: .all)
                ConfirmationAlert(alert: ConfirmationAlertType(
                    isPresented: $onboardingViewModel.showConfirmationAlert,
                    title: "Are you sure?",
                    message: "you can only change your goals once a week",
                    confirmAction: {
                        Task {
                            await onboardingViewModel.updateUserTarget()
                        }
                        router.popToRoot()
                    },
                    dismissAction: {
                        onboardingViewModel.showConfirmationAlert = false
                    }))
            }
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    router.navigateBack()
                }) {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                        Text("Back")
                            .font(.poppinsB1)
                    }
                }
                .foregroundColor(.red)
            }
        }
        .onAppear {
            Task {
                await onboardingViewModel.getUser()
                onboardingViewModel.updateCooldown()
            }
           
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ChangeVocabularyGoalsView()
}
