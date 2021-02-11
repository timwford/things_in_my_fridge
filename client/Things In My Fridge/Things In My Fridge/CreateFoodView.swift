//
//  CreateFoodView.swift
//  Things In My Fridge
//
//  Created by Tim Ford on 2/10/21.
//

import SwiftUI

struct CreateFoodView: View {
    
    @ObservedObject var foodModel = FoodModel.shared
    
    static var mealTypes = ["meal", "ingredient"]
    
    @State var foodName: String = ""
    @State var foodExpire: Int = 3
    @State var foodType: String = CreateFoodView.mealTypes[0]
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Going in the fridge is...").bold().font(.title)
                TextField("Food...", text: $foodName).font(.title2).padding(.horizontal, 32)
                
                Text("How long does it last?").bold().font(.title)
                HStack {
                    Text("-").font(.largeTitle).bold().shadow(radius: 4).onTapGesture {
                        if (foodExpire > 0) {
                            foodExpire -= 1
                        }
                    }.padding(.horizontal)
                    Text("\(foodExpire) days").font(.largeTitle).bold().padding(.horizontal)
                    Text("+").font(.largeTitle).bold().shadow(radius: 4).onTapGesture {
                        foodExpire += 1
                    }.padding(.horizontal)
                }.padding(.top)
                
                Picker("Type of food", selection: $foodType, content: {
                    ForEach(CreateFoodView.mealTypes, id: \.self) {
                        Text($0)
                    }
                })
                
                Button("Create", action: {
                    foodModel.update(schema: Food(name: foodName, expireDays: foodExpire, created: Int(NSDate().timeIntervalSince1970), active: true, foodType: foodType))
                })
                
                Spacer()
            }.padding(.top).onTapGesture {
                self.hideKeyboard()
            }
        }
    }
}

struct CreateFoodView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFoodView()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
