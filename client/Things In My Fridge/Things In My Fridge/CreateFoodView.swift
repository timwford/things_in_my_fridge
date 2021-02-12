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
    static var storageTypes = ["fridge", "freezer"]
    
    @State var foodName: String = ""
    @State var foodExpire: Int = 3
    @State var foodType: String = CreateFoodView.mealTypes[0]
    @State var storageType: String = CreateFoodView.storageTypes[0]
    
    @Binding var isPresented: Bool
    
    var body: some View {
        Form {
            Text("Going in the fridge is:").bold().font(.title)
            TextField("This kind of food...", text: $foodName).font(.title2)
            
            Section(header: Text("Storage")) {
                VStack {
                    Picker("Stored in ", selection: $storageType, content: {
                        ForEach(CreateFoodView.storageTypes, id: \.self) {
                            Text($0)
                        }
                    }).pickerStyle(SegmentedPickerStyle())
                }
                
                if storageType != "freezer" {
                    Text("How long does it last?").bold().font(.title)
                    
                    HStack(alignment: .center) {
                        Spacer()
                        
                        Text("-").font(.largeTitle).bold().shadow(radius: 4).onTapGesture {
                            if (foodExpire > 0) {
                                foodExpire -= 1
                            }
                        }.padding(.horizontal)
                        Text("\(foodExpire) days").font(.title2).bold().padding(.horizontal)
                        Text("+").font(.largeTitle).bold().shadow(radius: 4).onTapGesture {
                            foodExpire += 1
                        }.padding(.horizontal)
                        
                        Spacer()
                    }
                }
            }
            
            Section(header: Text("Type")) {
                Picker(selection: $foodType, label: Text("Type of Food")) {
                    ForEach(CreateFoodView.mealTypes, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
        }.navigationBarItems(trailing: Button(action: {
            foodModel.update(schema: Food(name: foodName, expireDays: foodExpire, created: Int(NSDate().timeIntervalSince1970), active: true, foodType: foodType, freezer: storageType == "freezer" ? true : false))
            
            self.isPresented = false
        }, label: {
            Text("Add").bold()
        })).navigationBarTitle("New Food!").navigationBarTitleDisplayMode(.large).onTapGesture {
            self.hideKeyboard()
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
