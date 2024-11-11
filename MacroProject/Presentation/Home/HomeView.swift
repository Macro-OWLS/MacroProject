import SwiftUI

struct HomeView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
//        ZStack {
//            Color(Color.black)
//                .ignoresSafeArea()
//
//            if onboardingViewModel.isLoading {
//                ProgressView()
//            } else {
                ScrollView(showsIndicators: true) {
                    VStack(alignment: .leading, spacing: -60) {
                        HomeHeaderContainer()
                        HomeFeatureContainer()
                    }
                    .padding(.top, 30)
                    .background(Color(Color.cream))  // Apply background here
                }
//            }
//        }
                .ignoresSafeArea(edges: .all)
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
}
