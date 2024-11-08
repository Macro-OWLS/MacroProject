import SwiftUI



struct OldLevelPage: View {
    @EnvironmentObject var levelViewModel: NewLevelViewModel
    @EnvironmentObject var router: Router

    var body: some View {
        NavigationView {
            ZStack {
                Color(Color.cream)
                    .ignoresSafeArea()

                VStack {
                    Rectangle()
                        .fill(Color.brown)
                        .frame(height: 1)

                    Spacer().frame(height: 32)

                    ForEach(levelViewModel.levels, id: \.level) { level in
                        Button(action: {
                            router.navigateTo(.levelSelectionPage(level))
                        }) {
                            ReviewBox(
                                level: level,
                                color: levelViewModel.setBackgroundColor(for: level),
                                strokeColor: levelViewModel.setStrokeColor(for: level)
                            )
                            .foregroundColor(levelViewModel.setTextColor(for: level))
                        }
                        .padding(.bottom, 8)
                        .padding(.horizontal, 16)
                    }
                    Spacer()
                }
                .foregroundColor(.black)
            }
            .navigationTitle("Review Time")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(levelViewModel.formattedDate())
                        .font(.poppinsH3)
                }
            }
        }
    }
}

struct LevelPage: View {
    var body: some View {
        ZStack(content: {
            Color.cream
                .ignoresSafeArea()

            ScrollView(showsIndicators: false, content: {
                VStack(alignment: .leading, spacing: 40, content: {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Review Time!")
                            .font(.poppinsH1)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                        Text("Boost memory with every review")
                            .font(.poppinsB1)
                            .multilineTextAlignment(.leading)
                    }

                    ZStack(alignment: .center, content: {
                        Image("Pathway")
                            .padding(.top, 40+100)

                        VStack(alignment: .leading, spacing: 110, content: {
                            // Card
                            HStack(alignment: .center, spacing: 0, content: {
                                Image("PhaseDoor")
                                    .padding([.trailing], 16)
                                VStack(alignment: .leading, spacing: 0, content: {
                                    Text("Phase 1")
                                        .font(.poppinsHd)
                                    Text("Memorize At Tuesday and Thursday")
                                        .frame(width: 186)
                                        .font(.poppinsB1)
                                })
                                Image(systemName: "chevron.right")
                            })
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
//                            .frame(width: 286, height: 120)
                            .background(Color.green)
                            .cornerRadius(16)
                        })
                    })
                })
            })
            .padding(.horizontal, 28)
        })
    }
}


#Preview {
    LevelPage()
//        .environmentObject(NewLevelViewModel())
}
