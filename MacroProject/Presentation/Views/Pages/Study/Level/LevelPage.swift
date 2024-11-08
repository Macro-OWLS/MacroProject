import SwiftUI
 


struct LevelPage: View {
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
            .navigationTitle("Study Time")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(levelViewModel.formattedDate())
                        .font(.helveticaHeader3)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
