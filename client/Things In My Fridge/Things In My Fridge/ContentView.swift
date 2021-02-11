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
            ScrollView {
                
                LazyVStack {
                    ForEach(foodModel.in_the_fridge) { food in
                        FoodView(food: food).padding([.horizontal, .top])
                    }
                }.sheet(isPresented: $isPuttingFoodInFridge, onDismiss: {
                    foodModel.load()
                }, content: {
                    CreateFoodView()
                })
                
            }.navigationBarItems(trailing: Button(action: {
                isPuttingFoodInFridge = true
            }, label: {
                Text("🐲").font(.title2).padding(8).background(RoundedRectangle(cornerRadius: 12).foregroundColor(.black).shadow(radius: 8))
            })).navigationBarTitle("In the fridge...").navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
