//import Foundation
//import Combine
//import SwiftData
//import SwiftUI
//import Supabase
//
//class DataSynchronizer: ObservableObject {
//    @Published var phrases: [PhraseCardModel] = []
//    private let supabase = SupabaseService.shared.getClient()
//
//    private var context: ModelContext? {
//        SwiftDataContextManager.shared.context
//    }
//    
//    private func fetchFromDatabase() async throws {
//        do {
//            let fetchedPhrases: [PhraseCardModel] = try await supabase
//                .database
//                .from("Phrases")
//                .select("phraseID, topicID, vocabulary, phrase, translation, isReviewPhase, boxNumber")
//                .execute()
//                .value
//            
//            DispatchQueue.main.async {
//                self.phrases = fetchedPhrases
//                print("Fetched phrases: \(self.phrases)")
//            }
//        } catch {
//            print(error)
//        }
//    }
//    
//    func saveToLocal() async throws {
//        try await fetchFromDatabase()
//        guard let context = context else {
//            print("Error: SwiftData context is not available.")
//            return
//        }
//        for phrase in phrases {
//            let phraseEntity = PhraseCardEntity(
//                id: phrase.id,
//                topicID: phrase.topicID,
//                vocabulary: phrase.vocabulary,
//                phrase: phrase.phrase,
//                translation: phrase.translation,
//                isReviewPhase: phrase.isReviewPhase,
//                boxNumber: phrase.boxNumber,
//                lastReviewedDate: nil,
//                nextReviewDate: nil
//            )
//            context.insert(phraseEntity)
//        }
//    
//        do {
//            try context.save()
//
//            print("Saved Data to local")
//        } catch {
//            print("Failed to save data to SwiftData: \(error)")
//        }
//    }
//    
//}
//
//
//struct Test: View {
//    @StateObject var viewmodel: DataSynchronizer
//    @State var phraseIDtoUpdate: String = ""
//
//    var body: some View {
//        NavigationView {
//            VStack{
//                List {
//                    ForEach(viewmodel.phrases) { topic in
//                        HStack{
//                            Text(topic.topicID)
//                            Text(topic.vocabulary)
//                            Text(topic.boxNumber)
//                            Spacer()
//                            
//                            
//                        }
//                    }.listStyle(.plain)
//                    
//                }
//                Spacer()
//            }.padding(20)
//            
//        }
//        .navigationTitle("TESTING")
//        .task {
//            try? await viewmodel.saveToLocal()
//        }
//        .refreshable {
//            try? await viewmodel.saveToLocal()
//        }
//    }
//
//}
//
