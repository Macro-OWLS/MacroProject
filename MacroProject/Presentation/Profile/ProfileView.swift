//
//  ProfileView.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 08/11/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @EnvironmentObject var router: Router
    
    @State private var showConfirmationAlert: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.cream
                .ignoresSafeArea(.all)
            
            ScrollView(content: {
                VStack(alignment: .center) {
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(Color.red)
                            .frame(width: 46, height: 46)
                        
                        VStack(alignment: .leading, spacing: -4) {
                            Text(homeViewModel.user.fullName ?? "Unknown")
                                .font(.poppinsH2)
                                .foregroundColor(.primary)
                            Text("Joined since \(homeViewModel.formattedJoinDate)")
                                .font(.poppinsB2)
                                .foregroundColor(Color.darkGrey)
                        }
                        .frame(alignment: .topLeading)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                    
                    VStack(spacing: 16) {
                        ZStack {
                            HStack(alignment: .top, spacing: 56) {
                                VStack(alignment: .leading, spacing: -2)  {
                                    Text("\(homeViewModel.streak ?? 99)")
                                        .font(.poppinsLargeTitle)
                                    
                                    HStack(alignment: .center, spacing: 5) {
                                        Image(systemName: "flame.fill")
                                            .frame(width: 16, height: 22)
                                            .foregroundColor(Color.red)
                                        Text("Day Streak!")
                                            .font(.poppinsH3)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 28, alignment: .leading)
                                    
//                                    if homeViewModel.isStreakComplete {
//                                        Text("Target complete!")
//                                            .font(.poppinsB1)
//                                            .padding(.top, -0)
//                                    } else {
//                                        Text("Review Target: \(homeViewModel.todayReviewedPhraseCounter) / \(homeViewModel.user.targetStreak ?? 99)")
//                                            .font(.poppinsB1)
//                                            .padding(.top, -0)
//                                    }
                                    Text("Review Target: \(homeViewModel.todayReviewedPhraseCounter) / \(homeViewModel.user.targetStreak ?? 99)")
                                        .font(.poppinsB2)
                                        .padding(.top, -0)

                                }
                                .padding(.top, -20)
                                .padding(0)
                                .frame(width: 155, alignment: .topLeading)
                                
                                Image("CapybaraProfile")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 102, height: 114)
                            }
                        }
                        .padding(24)
                        .frame(width: 344, height: 162, alignment: .topLeading)
                        .background(Color.lightBrown)
                        .cornerRadius(30)
                        
                        // Words Added and Retained Section
                        HStack(alignment: .center, spacing: 8) {
                            ZStack {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("\(homeViewModel.reviewedPhraseCount)")
                                        .font(.poppinsH1)
                                    
                                    HStack(alignment: .top, spacing: 4) {
                                        Image(systemName: "bookmark.fill")
                                            .frame(width: 12, height: 20)
                                            .foregroundStyle(Color.green)
                                        Text("Words Added")
                                            .font(.poppinsB2)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                                .frame(width: 136, alignment: .topLeading)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 24)
                            .frame(width: 168, height: 127)
                            .background(Color.lightBrown)
                            .cornerRadius(30)
                            
                            // Words Retained Card
                            ZStack {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("\(homeViewModel.retainedPhraseCount)")
                                        .font(.poppinsH1)
                                    
                                    HStack(alignment: .top, spacing: 4) {
                                        Image(systemName: "brain.fill")
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(Color.lightRedSemantics)
                                        Text("Words Retained")
                                            .font(.poppinsB2)
                                    }
                                    .frame(width: 136, alignment: .topLeading)
                                }
                                .frame(width: 136, alignment: .topLeading)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 24)
                            .frame(width: 168, height: 127)
                            .background(Color.lightBrown)
                            .cornerRadius(30)
                        }
                        .frame(width: 344, height: 129, alignment: .leading)
                    }
                    .padding(.top, 20)
                    .frame(width: 344, alignment: .topTrailing)
                    
                    // Language and FAQ Options
                    VStack(alignment: .leading, spacing: 18) {
                        Button(action: {
                            router.navigateTo(.changeTarget)
                        }) {
                            HStack(alignment: .top, spacing: 0) {
                                Text("Change Vocabulary Goals")
                                    .font(.poppinsB1)
                                    .frame(height: 22, alignment: .topLeading)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        
                        Button(action: {
                            router.navigateTo(.faqView)
                        }) {
                            HStack(alignment: .top, spacing: 0) {
                                Text("Frequently Ask Questions")
                                    .font(.poppinsB1)
                                    .frame(width: 227, height: 22, alignment: .topLeading)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 32)
                    .foregroundColor(.black)
                    
                    VStack(alignment: .center, spacing: 16) {
                        Button(action: {
                                showConfirmationAlert = true
                        }) {
                            Text("Delete Profile")
                                .foregroundColor(.red)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .frame(width: 148, alignment: .center)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .inset(by: 0.5)
                                        .stroke(Color.red, lineWidth: 1)
                                )
                        }
                        
                        Button(action: {
                            Task {
                                await onboardingViewModel.signOut()
                            }
                            router.navigateTo(.welcomeView)
                        }) {
                            Text("Log Out")
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .frame(width: 148, alignment: .center)
                                .background(Color.red)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.top, 100)
                }
                .padding(.top, 20)
            })
            
            if showConfirmationAlert {
                Color.black.opacity(0.4).ignoresSafeArea(edges: .all)
                VStack(content: {
                    Spacer()
                    ConfirmationAlert(alert: ConfirmationAlertType(isPresented: $showConfirmationAlert, title: "Are You Sure?", message: "It will delete your account!", confirmAction: {
                        Task {
                            showConfirmationAlert = false
                            await onboardingViewModel.deleteAccount()
                        }
                        router.navigateTo(.welcomeView)
                    }, dismissAction: {
                        showConfirmationAlert = false
                    }))
                    Spacer()
                })
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !showConfirmationAlert {
                    Button(action: {
                        router.navigateBack()
                    }) {
                        HStack(alignment: .center, spacing: 4, content: {
                            Image(systemName: "chevron.left")
                                .fontWeight(.semibold)
                            Text("Back")
                                .font(.poppinsB1)
                        })
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ProfileView()
        .environmentObject(HomeViewModel())
        .environmentObject(OnboardingViewModel())
}
