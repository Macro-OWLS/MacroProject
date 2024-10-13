//
//  LevelPage.swift
//  MacroProject
//
//  Created by Agfi on 11/10/24.
//

import SwiftUI

struct Level {
    let level: Int
    let title: String
    let description: String
}

struct LevelPage: View {
    init() {
        setupNavigationBarAppearance()
    }
    
    var levels: [Level] = [
        .init(level: 1, title: "Level 1", description: "Learn this everyday"),
        .init(level: 2, title: "Level 2", description: "Learn this every Tuesday & Thursday"),
        .init(level: 3, title: "Level 3", description: "Learn this every Friday"),
        .init(level: 4, title: "Level 4", description: "Learn this biweekly on Friday"),
        .init(level: 5, title: "Level 5", description: "Learn this once a month")
    ]
    
    var body: some View {
        NavigationView(content: {
            VStack {
                ForEach(levels, id: \.level) { level in
                    NavigationLink(destination: LevelSelectionPage(level: level)) {
                        ReviewBox(level: level, color: setBackgroundColorBox())
                    }
                    .padding(.bottom, 8)
                }
                Spacer()
            }
//            .background(Color(.cream))
            .foregroundColor(.black)
            .padding(.top, 32)
            .padding(.horizontal, 16)
            .navigationTitle("Study Time")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    Text(formattedDate())
                        .font(.helveticaHeader3)
                })
            }
        })
    }
    
    func setBackgroundColorBox() -> Color {
        return .cream
    }
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMM yyyy"
        return dateFormatter.string(from: Date())
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "Cream")
        
        appearance.shadowColor = UIColor.black
        appearance.shadowColor?.withAlphaComponent(1)
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    ContentView()
}
