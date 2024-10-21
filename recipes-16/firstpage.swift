//
//  firstpage.swift
//  recipes-16
//
//  Created by Renad Alotaibi on 18/04/1446 AH.
//

import SwiftUI

import SwiftUI

struct firstPage: View { // Capitalized struct name for Swift naming convention
    @State var recipes: [String] = []
    @State private var newRecipe: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Food Recipes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)

                    Spacer()

                    NavigationLink(destination: AddRecipes(recipes: $recipes)) {
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                    }
                    .padding(.trailing)
                }
                .padding(.top)
                Spacer()
                
                if recipes.isEmpty {
                    VStack {
                        Image("Food")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 325, height: 327)
                            .foregroundColor(.white)
                            .padding()
                        
                        Text("There's No recipe yet")
                            .font(.custom("SF Pro", size: 34)).bold()
                        Text("Please add your recipes")
                            .font(.custom("SF Pro", size: 22))
                            .padding()
                    }
                    .transition(.opacity)
                } else {
                    List {
                        ForEach(recipes, id: \.self) { recipe in
                            Text(recipe)
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

struct AddRecipes: View {
    @Binding var recipes: [String]
    @State private var newRecipe: String = ""

    var body: some View {
        VStack {
            TextField("Enter recipe name", text: $newRecipe)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                if !newRecipe.isEmpty {
                    recipes.append(newRecipe)
                }
            }) {
                HStack {
                    Text("Food Recipes")
                      
                    
                    Spacer()
                }
            }

            Spacer()
        }
        .navigationTitle("New Recipe").font(.largeTitle)
        .fontWeight(.bold)
        .padding(.leading)
        .padding()
    }
}

#Preview {
    firstPage()
}
