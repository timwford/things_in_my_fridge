//
//  ContentView.swift
//  Things In My Fridge
//
//  Created by Tim Ford on 2/10/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var foodModel = FoodModel.shared
    
    @State var isPuttingFoodInFridge = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                
                Button(action: {
                    isPuttingFoodInFridge = true
                }, label: {
                    Text("~~🐲~~").font(.largeTitle).shadow(radius: 8).padding(8)
                })
                
                Text("Fridge").bold().font(.largeTitle)
                
                VStack {
                    NavigationLink(destination: CreateFoodView(isPresented: $isPuttingFoodInFridge), isActive: $isPuttingFoodInFridge, label: {
                        EmptyView()
                    })
                    
                    ForEach(foodModel.in_the_fridge) { food in
                        if !food.freezer {
                            FoodSeparatorView(color: FoodView.getColorForSpoiled(food))
                            FoodView(food: food)
                        }
                    }
                }
                
                Text("Freezer").bold().font(.largeTitle).padding(.top)
                
                VStack {
                    ForEach(foodModel.in_the_fridge) { food in
                        if food.freezer {
                            FoodView(food: food)
                        }
                    }
                }
            }.padding([.horizontal], 8).navigationBarTitle("Food Stuffs").navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
