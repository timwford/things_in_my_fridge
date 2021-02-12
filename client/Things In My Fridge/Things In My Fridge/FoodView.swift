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
    @State var isFreezing: Bool = false
    
    
    static func daysUntilSpoiled(_ food: Food) -> Int {
        let now = NSDate().timeIntervalSince1970
        let future_date = food.created + food.expireDays*86400
        let difference = abs(now - Double(future_date))
        return Int(round(difference/86400))
    }
    
    static func getColorForSpoiled(_ food: Food) -> Color {
        
        let spoils = FoodView.daysUntilSpoiled(food)
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
            HStack {
                VStack {
                    if !food.freezer {
                        RoundedRectangle(cornerRadius: 28).foregroundColor(FoodView.getColorForSpoiled(food)).shadow(radius: 2).padding(.leading,2)
                    }
                }.frame(width: 16, height: 42, alignment: .center)
                
                Text("\(food.name)").bold().font(.title2)
                
                Spacer()
                
                Button(action: {
                    isFreezing = true
                }, label: {
                    Text(food.freezer == true ? "☀️" : "🧊").bold().font(.title3).foregroundColor(.white).padding(4)
                }).padding(4.0).background(RoundedRectangle(cornerRadius: 8).foregroundColor(food.freezer == true ? .pink : .blue).shadow(radius: 4)).padding(.trailing, 6).alert(isPresented: $isFreezing, content: {
                    Alert(title: Text(food.freezer == true ? "Start to thaw?" : "Place in the freezer?"), primaryButton: Alert.Button.cancel(), secondaryButton: Alert.Button.default(Text("Yes!"), action: {
                        var newFood = food
                        newFood.freezer = !food.freezer
                        FoodModel.shared.update(schema: newFood)
                    }))
                })
                
                Button(action: {
                    isEating = true
                }, label: {
                    Text(food.foodType == "meal" ? "🍽" : "🥣").bold().font(.title3).foregroundColor(.white).padding(4)
                }).padding(4.0).background(RoundedRectangle(cornerRadius: 8).foregroundColor(.gray).shadow(radius: 4)).padding(.trailing, 6).alert(isPresented: $isEating, content: {
                    Alert(title: Text("You sure it's gone?"), primaryButton: Alert.Button.cancel(), secondaryButton: Alert.Button.default(Text("All gone!"), action: {
                        var newFood = food
                        newFood.active = false
                        FoodModel.shared.update(schema: newFood)
                    }))
                })
            }
        }.padding(4)
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView(food: Food(name: "Hummus", expireDays: 4, created: 12345666, active: true, foodType: "meal", freezer: false, id: "ffff"))
    }
}
