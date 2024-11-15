import SwiftUI

struct LevelPage: View {
    @EnvironmentObject var levelViewModel: LevelViewModel
    @EnvironmentObject var levelSelectionViewModel: LevelSelectionViewModel
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

#Preview {
    LevelPage()
        .environmentObject(LevelViewModel())
        .environmentObject(Router())
}
