//
//  FoodView.swift
//  Things In My Fridge
//
//  Created by Tim Ford on 2/10/21.
//

import SwiftUI

struct FoodView: View {
    
    var food: Food
    
    @State var isEating: Bool = false
    
    func daysUntilSpoiled(_ food: Food) -> Int {
        let now = NSDate().timeIntervalSince1970
        let future_date = food.created + food.expireDays*86400
        let difference = abs(now - Double(future_date))
        return Int(round(difference/86400))
    }
    
    func getColorForSpoiled(_ food: Food) -> Color {
        let spoils = daysUntilSpoiled(food)
        print(spoils)
        
        if spoils > 3 {
            return .green
        } else if spoils > 1 {
            return .yellow
        } else {
            return .red
        }
    }
    
    var body: some View {
        VStack {
            Divider()
            
            HStack {
                VStack {
                    Text("\(food.name) (\(daysUntilSpoiled(food)))").bold().font(.title2)
                    RoundedRectangle(cornerRadius: 24).foregroundColor(getColorForSpoiled(food)).shadow(radius: 8)
                }.padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    isEating = true
                }, label: {
                    Text(food.foodType == "meal" ? "🍽" : "🥣").bold().font(.title3).foregroundColor(.white).padding(4)
                }).padding(4.0).background(RoundedRectangle(cornerRadius: 8).foregroundColor(.blue).shadow(radius: 8))
            }
            
        }.padding(.horizontal).alert(isPresented: $isEating, content: {
            Alert(title: Text("You sure it's gone?"), primaryButton: Alert.Button.cancel(), secondaryButton: Alert.Button.default(Text("All gone!"), action: {
                var newFood = food
                newFood.active = false
                FoodModel.shared.update(schema: newFood)
            }))
        })
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView(food: Food(name: "Hummus", expireDays: 4, created: 12345666, active: true, foodType: "meal", id: "ffff"))
    }
}
