import SwiftUI

struct HomeView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var router: Router
    
    @State private var isScrolling = false
    
    var body: some View {
        ZStack {
            Color(Color.lightBrown3)
                .ignoresSafeArea()
            
            if onboardingViewModel.isLoading {
                ProgressView()
            } else {
                ScrollView(showsIndicators: true) {
                    GeometryReader { geometry in
                        Color.clear
                            .onChange(of: geometry.frame(in: .global).minY) { offsetY in
                                isScrolling = offsetY < 0
                            }
                    }
                    .frame(height: 0)

                    VStack(spacing: -40) {
                        HomeHeaderContainer()
                        HomeFeatureContainer()
                    }
                    .background(Color(Color.lightBrown3))
                }
                .onAppear{
                    Task {
                        await homeViewModel.getStreakData()
                        await homeViewModel.updateOnGoingStreak()
                        await homeViewModel.updateUserStreak()
                        await homeViewModel.reviewedPhraseCounter()
                        await homeViewModel.retainedPhraseCounter()
                    }
                }
            }
            
            if isScrolling {
                VStack {
                    Color(Color.lightBrown3)
                        .frame(maxWidth: .infinity, maxHeight: 70)
                        .ignoresSafeArea()
                    Spacer()
                }
                .transition(.opacity)
                .animation(.easeInOut, value: isScrolling)
            }
        }
        .ignoresSafeArea()

    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    HomeView()
        .environmentObject(OnboardingViewModel())
        .environmentObject(HomeViewModel())
        .environmentObject(Router())
}
