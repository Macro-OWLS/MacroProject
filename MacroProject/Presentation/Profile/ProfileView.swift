//
//  ProfileView.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 08/11/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            Color.cream // Background color set on ZStack
                .ignoresSafeArea(.all)
            
            VStack(alignment: .leading) {
                // Profile Header
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(Color.red)
                        .frame(width: 46, height: 46)
                    
                    VStack(alignment: .leading, spacing: -4) {
                        Text(homeViewModel.user.fullName ?? "Unknown")
                            .font(.poppinsH2)
                            .foregroundColor(.primary)
                        Text("Joined since Nov 24")
                            .font(.poppinsB2)
                            .foregroundColor(Color.darkGrey)
                    }
                    .frame(alignment: .topLeading)
                }
                .padding(.bottom, 35)
                
                // Brown Card Frame
                VStack(spacing: 16) {
                    // Streak Information Card
                    ZStack {
                        HStack(alignment: .top, spacing: 56) {
                            VStack(alignment: .leading, spacing: -2)  {
                                Text("\(homeViewModel.user.streak ?? 5)")
                                    .font(.poppinsLargeTitle)
                                
                                HStack(alignment: .center, spacing: 5) {
                                    Image(systemName: "flame.fill")
                                        .frame(width: 16, height: 22)
                                        .foregroundColor(Color.red)
                                    Text("Day Streak!")
                                        .font(.poppinsH3)
                                }
                                .frame(maxWidth: .infinity, minHeight: 28, alignment: .leading)
                                
                                Text("Longest Streak: \(homeViewModel.user.streak ?? 5)")
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
                        // Words Added Card
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
                .padding(0)
                .frame(width: 344, alignment: .topTrailing)
                
                // Language and FAQ Options
                VStack(alignment: .leading, spacing: 18) {
                    HStack(alignment: .top, spacing: 131) {
                        Text("Switch Language")
                            .font(.poppinsB1)
                            .frame(width: 186, height: 22, alignment: .topLeading)
                        
                        Image(systemName: "chevron.right")
                    }
                    
                    HStack(alignment: .top, spacing: 90) {
                        Text("Frequently Ask Questions")
                            .font(.poppinsB1)
                            .frame(width: 227, height: 22, alignment: .topLeading)
                        
                        Image(systemName: "chevron.right")
                    }
                }
                .padding(.top, 20)
                .frame(width: 306, alignment: .leading)
            }
            .padding(.top, -150)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    router.popToRoot()
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
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ProfileView()
        .environmentObject(HomeViewModel())

}

