//
//  TimeDividerView.swift
//  Things In My Fridge
//
//  Created by Tim Ford on 2/11/21.
//

import SwiftUI

struct TimeDividerView: View {
    
    var text: String
    var color: Color
    
    init (text: String, color: Color) {
        self.text = text
        self.color = color
        
        if color == .red {
            FoodSeparatorModel.shared.now = true
        } else if color == .yellow {
            FoodSeparatorModel.shared.soon = true
        } else if color == .green {
            FoodSeparatorModel.shared.eventually = true
        } else if color == .blue {
            FoodSeparatorModel.shared.frozen = true
        }
    }
    
    var body: some View {
        HStack {
            VStack {
                Divider()
            }
            Text(text).bold().font(.subheadline).padding(.horizontal, 4)
            VStack {
                Divider()
            }
        }.padding(.horizontal)
    }
}

struct TimeDividerView_Previews: PreviewProvider {
    static var previews: some View {
        TimeDividerView(text: "Eat Soon", color: .red)
    }
}
