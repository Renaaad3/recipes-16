//
//  firstpage.swift
//  recipes-16
//
//  Created by Renad Alotaibi on 18/04/1446 AH.
//

import SwiftUI

func saveRecipesToUserDefaults(recipes: [String]) {
    UserDefaults.standard.set(recipes, forKey: "recipes")
}

func loadRecipesFromUserDefaults() -> [String] {
    return UserDefaults.standard.stringArray(forKey: "recipes") ?? []
}
struct firstPage: View { // Capitalized struct name for Swift naming convention
    @State var recipes: [String] = []
    @State private var newRecipe: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Spacer()
                    NavigationLink(destination: AddRecipes(recipes: $recipes)) {
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                    }
                    .padding(.trailing)
                }
                HStack {
                    Text("Food Recipes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)

                    Spacer()
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
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedImage: UIImage? = nil
        @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
           
            Button(action: {
                if !newRecipe.isEmpty {
                    recipes.append(newRecipe)
                }
            }) {
                Spacer()
                HStack {
                    Text("Save")
                    .foregroundStyle(.orange)                }
                   .padding(.trailing)
                
            }
        
        
            HStack {
                Text("New Recipe")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                
                Spacer()
                
            }            .padding()
            HStack{
           
            Button(action: {
                            showingImagePicker = true
                        }) {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            } else {
                                VStack{
                                    Image("photo")
                                        .frame(width: 413, height: 181)
                                        .padding(.horizontal)
                                    
                                    Text("Upload Photo").font(.custom("SF PRO", size: 22)).bold()
                            
                                        .foregroundStyle(.black)
                                        .padding(.top,8)
                                }
                                .background(Color.gray.opacity(0.2))
                            }
                        }
                        .padding(.bottom)
            }

            HStack{
                Text("Title")
                    .font(.custom("SF Pro", size: 24))
                   
                    .padding(.leading)
                Spacer()
            }
            
                TextField("Title", text: $title)
                .font(.custom("SF Pro", size: 24)).foregroundColor(Color(red: 117 / 255, green: 117 / 255, blue: 117 / 255) )
                
                .padding()
                    .background(Color.gray.opacity(0.2))
                    .frame(width: 366, height: 47)
                    .cornerRadius(8)
                    .padding(.bottom)
                
            HStack{
                Text("Description")
                    .font(.custom("SF Pro", size: 24))
                   
                    .padding(.leading)
                Spacer()
            }
            
            TextField("Description", text: $description )
                .padding(.top)
                .font(.custom("SF Pro", size: 24)).padding(.top)
                .frame(width: 367, height: 130)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.bottom)
            
            
                Spacer()
            }
            
        }
    }
#Preview {
    firstPage()
}
