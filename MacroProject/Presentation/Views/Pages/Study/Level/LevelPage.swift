import SwiftUI

struct LevelPage: View {
    @EnvironmentObject var levelViewModel: NewLevelViewModel
    @EnvironmentObject var router: Router
    @Binding var selectedTabView: TabViewType
    
    init(selectedTabView: Binding<TabViewType>) {
        _selectedTabView = selectedTabView
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(Color.darkcream)
                    .ignoresSafeArea()
                ScrollView {
                    
                    VStack {
                        HStack(alignment: .top) {
                            Text("Time to memorize what you’ve learned!")
                                .font(.helveticaBody1)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        
                        ReviewBox(level: LevelType.phase1, color: .cream)
                            .padding(.top, 30)
                            .padding(.trailing, 50)
                        
                        ReviewBox(level: LevelType.phase2, color: .cream)
                            .padding(.top, 106)
                            .padding(.leading, 50)
                        
                        ReviewBox(level: LevelType.phase3, color: .cream)
                            .padding(.top, 106)
                            .padding(.trailing, 50)
                        
                        ReviewBox(level: LevelType.phase4, color: .cream)
                            .padding(.top, 106)
                            .padding(.leading, 50)
                        
                        ReviewBox(level: LevelType.phase5, color: .cream)
                            .padding(.top, 106)
                            .padding(.trailing, 50)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        Road()
                            .padding(.top, 160)
                    }
                }
                .scrollIndicators(.never)
            }
            .navigationTitle("Review Time")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct LevelPage_Previews: PreviewProvider {
    static var previews: some View {
        
        let topicLibraryViewModel = TopicViewModel()
        let phraseLibraryCardViewModel = PhraseCardViewModel()
        let levelViewModel = LevelViewModel()
        let newLevelViewModel = NewLevelViewModel()
        let levelSelectionViewModel = LevelSelectionViewModel()
        let newLevelSelectionViewModel = NewLevelSelectionViewModel()
        let studyPhraseViewModel = StudyPhraseViewModel()
        let libraryViewModel = LibraryViewModel(topicViewModel: topicLibraryViewModel)
        
        return LevelPage(selectedTabView: .constant(.study))
            .environmentObject(topicLibraryViewModel)
            .environmentObject(phraseLibraryCardViewModel)
            .environmentObject(levelViewModel)
            .environmentObject(newLevelViewModel)
            .environmentObject(levelSelectionViewModel)
            .environmentObject(newLevelSelectionViewModel)
            .environmentObject(studyPhraseViewModel)
            .environmentObject(libraryViewModel)
    }
}

/*
 ForEach(levelViewModel.levels, id: \.level) { level in
     Button(action: {
         router.navigateTo(.levelSelectionPage(level, $selectedTabView))
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
 */
