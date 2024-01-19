//
//  SwiftUI
//  Copyright © 2024 Vladimir Rybant. All rights reserved.
//

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-search-bar-to-filter-your-data

import SwiftUI

struct Food: Identifiable {
    var name: String
    var icon: String
    var isFavorite: Bool
    let id = UUID() // Universal Unique Identifier

    static func preview() -> [Food] {
        return [Food(name: "Apple", icon: "🍎", isFavorite: true),
                Food(name: "Cherry", icon: "🍒", isFavorite: false),
                Food(name: "Strawberry", icon: "🍓", isFavorite: false),
                Food(name: "Graps", icon: "🍇", isFavorite: true)
        ]
    }
}

struct SearchView: View {
    @State private var foods = Food.preview()
    @State private var searchText = ""
    @State private var searchIsActive = false

    var body: some View {
        VStack {
            NavigationStack {
                List (foods) { food in
                    HStack {
                        Text(food.icon)
                        Text(food.name)
                        Spacer()
                        Image(systemName: food.isFavorite ? "heart.fill" : "heart")
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Search")
            }
            .searchable(text: $searchText, isPresented: $searchIsActive, prompt: "Search text")
            .onChange(of: searchText) {
                print(searchText)
            }
            .onSubmit {
                print(searchText)
            }
        }
    }
}

struct FoodRow: View {
    let food: Food

    var body: some View {
        HStack {
            Text(food.icon)
            Text(food.name)
            Spacer()
            Image(systemName: food.isFavorite ? "heart.fill" : "heart")
        }
    }
}
             
#Preview {
    SearchView()
}
