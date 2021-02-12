//
//  FoodSeparatorView.swift
//  Things In My Fridge
//
//  Created by Tim Ford on 2/11/21.
//

import SwiftUI

class FoodSeparatorModel: ObservableObject {
    var now = false
    var soon = false
    var eventually = false
    var frozen = false
    
    static var shared = FoodSeparatorModel()
}

struct FoodSeparatorView: View {
    
    var color: Color
    
    var body: some View {
        if color == .red && !FoodSeparatorModel.shared.now {
            TimeDividerView(text: "Eat it", color: .red).padding(.top, FoodSeparatorModel.shared.now ? 0 : 8)
        } else if color == .yellow && !FoodSeparatorModel.shared.soon {
            TimeDividerView(text: "Soon", color: .yellow).padding(.top, FoodSeparatorModel.shared.now ? 0 : 8)
        } else if color == .green && !FoodSeparatorModel.shared.eventually {
            TimeDividerView(text: "Golden 🦧", color: .green).padding(.top, FoodSeparatorModel.shared.now ? 0 : 8)
        } else if color == .blue && !FoodSeparatorModel.shared.frozen {
        }
    }
}

struct FoodSeparatorView_Previews: PreviewProvider {
    static var previews: some View {
        FoodSeparatorView(color: .red)
    }
}
