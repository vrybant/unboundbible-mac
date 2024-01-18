//
//  SwiftUI
//  Copyright © 2024 Vladimir Rybant. All rights reserved.
//

import SwiftUI

struct Food: Identifiable {
    var name: String
    var icon: String
    var isFavorite: Bool
    let id = UUID() // Universal Unique Identifier

    static func preview() -> [Food] {
        return [Food(name: "Apple", icon: "🍎", isFavorite: true),
                Food(name: "Banana", icon: "🍌", isFavorite: false),
                Food(name: "Cherry", icon: "🍒", isFavorite: false),
                Food(name: "Mango", icon: "🥭", isFavorite: true),
                Food(name: "Kiwi", icon: "🥝", isFavorite: false),
                Food(name: "Strawberry", icon: "🍓", isFavorite: false),
                Food(name: "Graps", icon: "🍇", isFavorite: true)
        ]
    }
}

struct SearchView: View {
    @State private var foods = Food.preview()

    var body: some View {
        List (foods) { food in
//          FoodRow(food: food)
            HStack {
                Text(food.icon)
                Text(food.name)
                Spacer()
                Image(systemName: food.isFavorite ? "heart.fill" : "heart")
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
