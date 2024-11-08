import SwiftUI



struct OldLevelPage: View {
    @EnvironmentObject var levelViewModel: LevelViewModel
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
    @EnvironmentObject var levelViewModel: LevelViewModel
    @EnvironmentObject var router: Router
    
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
                    .frame(width: 337, alignment: .topLeading)
                    

                    ZStack(alignment: .top, content: {
                        Image("Pathway")
                            .padding(.top, -20)

                        VStack(alignment: .leading, spacing: 110, content: {
                            // Card
                            ForEach(levelViewModel.levels, id: \.level) { level in
                                ReviewCard(level: level, foregroundColor: levelViewModel.setTextColor(for: level), backgroundColor: levelViewModel.setBackgroundColor(for: level), isCurrentDay: levelViewModel.isCurrentDay(for: level)) {
                                    router.navigateTo(.levelSelectionPage(level))
                                }
                            }
                        })
                        .offset(y: 0)
                    })
                })
            })
            .padding(.horizontal, 28)
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
        })
    }
}

struct ReviewCard: View {
    let level: Level
    let foregroundColor: Color
    let backgroundColor: Color
    let isCurrentDay: Bool
    let onTap: () -> Void
    @State private var isTapped = false
    @State private var isImageTapped = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            if level.level % 2 == 0 {
                Image("CapybaraRecapLeft")
                    .scaleEffect(isImageTapped ? 0.9 : 1.0)
                    .rotationEffect(isImageTapped ? .degrees(10) : .degrees(0))
                    .offset(x: isImageTapped ? -5 : 0)
                    .opacity(isCurrentDay ? 1.0 : 0.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.4, blendDuration: 0), value: isImageTapped)
                    .onTapGesture {
                        withAnimation {
                            isImageTapped = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            isImageTapped = false
                        }
                    }
            }
            
            HStack(alignment: .center, spacing: 0, content: {
                Image(isCurrentDay ? "PhaseDoor" : "PhaseDoorGrey")
                    .padding([.trailing], 16)
                VStack(alignment: .leading, spacing: 0, content: {
                    Text(level.title)
                        .font(.poppinsHd)
                        .frame(width: 186, alignment: .leading)
                    Text(level.description)
                        .frame(width: 186, alignment: .leading)
                        .font(.poppinsB1)
                })
                Image(systemName: "chevron.right")
            })
            .foregroundColor(isCurrentDay ? .white : .grey)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(isCurrentDay ? Color.green : Color.gray)
            .cornerRadius(16)
            .scaleEffect(isTapped ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: isTapped)
            .onTapGesture {
                withAnimation {
                    isTapped = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    onTap()
                    isTapped = false
                }
            }
            
            if level.level % 2 != 0 {
                Image("CapybaraRecapLeft")
                    .scaleEffect(isImageTapped ? 0.9 : 1.0)
                    .rotationEffect(isImageTapped ? .degrees(-10) : .degrees(0))
                    .offset(x: isImageTapped ? 5 : 0)
                    .opacity(isCurrentDay ? 1.0 : 0.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.4, blendDuration: 0), value: isImageTapped)
                    .onTapGesture {
                        withAnimation {
                            isImageTapped = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            isImageTapped = false
                        }
                    }
            }
        }
    }
}

#Preview {
    LevelPage()
        .environmentObject(LevelViewModel())
        .environmentObject(Router())
}
