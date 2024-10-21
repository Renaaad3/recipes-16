//
//  firstpage.swift
//  recipes-16
//
//  Created by Renad Alotaibi on 18/04/1446 AH.
//

import SwiftUI

struct firstpage: View {
    @State var recipes: [String] = []
    @State private var newRecipe: String = ""
    var body: some View {
        
        NavigationView {
            VStack{
                
                HStack {
                    Text("Food Recipes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    Spacer()
                    
                    NavigationLink(destination: AddRecipe(recipes: $recipes)) {
                                         Image(systemName: "plus.circle.fill")
                                             .font(.largeTitle)
                                             .foregroundColor(.orange)
                                     }
                                     .padding(.trailing)
                                 }
                                 .padding(.top)
                
                
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
#Preview {
    firstpage()
}
