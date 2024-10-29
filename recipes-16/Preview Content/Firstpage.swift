import SwiftUI
import PhotosUI

// Struct for picking an image from the photo library
struct ImagePicker: View {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        PhotosPicker(selection: $selectedItem) {
            Text("Select a photo")
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let newItem = newItem {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            image = uiImage
                        }
                    }
                }
                dismiss()
            }
        }
    }
}

// Main View for displaying recipes
struct FirstPage: View {
    @State private var recipes: [Recipe] = []
    @State private var searchText: String = ""
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipes
        } else {
            return recipes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(destination: AddRecipeView(recipes: $recipes)) {
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
                    if !recipes.isEmpty {
                        TextField("Search Recipes", text: $searchText)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .padding()
                        
                        List(filteredRecipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe, recipes: $recipes)) {
                                VStack(alignment: .leading) {
                                    if let image = recipe.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 414, height: 272)
                                            .cornerRadius(10)
                                    
                                    } else {
                                        VStack {
                                            Text(recipe.title)
                                                .font(.headline).foregroundColor(.white)
                                                .padding(.top, 5)
                                                
                                            
                                            Text(recipe.description)
                                                .font(.subheadline)
                                                .foregroundColor(.white)

                                            
                                            Image("placeholder")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 414, height: 272)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                                .padding(.vertical)
                            }
                        }
        
                    
                } else {
                    VStack {
                        Image("Food")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 325, height: 327)
                            .padding()
                        
                        Text("There's No recipe yet")
                            .font(.custom("SF Pro", size: 34)).bold()
                        Text("Please add your recipes")
                            .font(.custom("SF Pro", size: 22))
                            .padding()
                    
                    }
                    
                    .transition(.opacity)
                }
            }
            .onAppear {
                loadRecipes()
            }
        }
    }

    private func loadRecipes() {
        recipes = loadRecipesFromUserDefaults()
    }
}

// View for adding/editing recipes
struct AddRecipeView: View {
    @Binding var recipes: [Recipe]
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var ingredients: [Ingredient] = []
    @State private var selectedImage: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var newIngredientName: String = ""
    @State private var selectedMeasurement: String = "spoon"
    @State private var showingIngredientPopup = false
    @State private var servingSize: Int = 1 // Changed to Int
    
    var recipeToEdit: Recipe?

    var body: some View {
        ScrollView {
            VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    if !title.isEmpty {
                                        // Use imageData instead of image
                                        let newRecipe = Recipe(title: title, description: description, ingredients: ingredients, imageData: selectedImage?.pngData())
                                        
                                        if let recipeToEdit = recipeToEdit {
                                            if let index = recipes.firstIndex(where: { $0.id == recipeToEdit.id }) {
                                                recipes[index] = newRecipe
                                            }
                                        } else {
                                            recipes.append(newRecipe)
                                        }
                                        saveRecipesToUserDefaults(recipes: recipes)
                                    }
                                }) {
                                    Text(recipeToEdit != nil ? "Update   " : "Save     ")
                                        .foregroundColor(.orange)
                                        .padding()
                                }
                                
                                
                            }
                            HStack{
                                Text(recipeToEdit != nil ? "  Edit Recipe" : "  New Recipe")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .padding(.leading)
                                
                                Spacer()
                                
                            }
                           
                            
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                if let selectedImage = selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                } else {
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                                                .foregroundColor(.orange)
                                                .frame(width: 413, height: 181)
                                                .background(Color.gray.opacity(0.2))
                                            
                                            VStack {
                                                Image("photo")
                                                
                                                    .scaledToFit()
                                                    .frame(width: 200, height: 120)
                                                    .padding(.bottom, 5)
                                                
                                                Text("Upload Photo")
                                                    .font(.custom("SF Pro", size: 22))
                                                    .foregroundColor(.black)
                                                    .bold()
                                                
                                            }
                                            .padding()
                                            
                                        }
                                        .padding()
                                    }
                                
                                }
                            }
                            .sheet(isPresented: $showingImagePicker) {
                                ImagePicker(image: $selectedImage)
                            }
                Spacer()

                TextField("Title", text: $title)
                                    .padding()
                                    .frame(width: 366, height: 47)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .padding(.bottom)

                TextField("Description", text: $description)
                                    .frame(width: 367, height: 130)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .padding(.bottom)

                // Button to show the ingredient input popup
                HStack {
                    Text("Add Ingredient")
                        .font(.custom("SF Pro", size: 24))
                        .fontWeight(.bold)
                        .padding(.leading)
                    Spacer()
                    
                    Button(action: {
                        showingIngredientPopup = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.orange)
                            .font(.custom("SF Pro", size: 24))
                            .bold()
                    }
                    .padding(.trailing)
                }
                .padding()

                // Popup for adding ingredients
                if showingIngredientPopup {
                    VStack {
                        Text("Ingredient Name")
                            .font(.headline)
                            .padding(.leading)
                        TextField("Enter Ingredient Name", text: $newIngredientName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom)
                        
                        // Measurement Section with Buttons
                        Text("Measurement")
                        HStack {
                            Button(action: {
                                selectedMeasurement = "spoon"
                            }) {
                                HStack {
                                    Text("🥄")
                                        .font(.system(size: 20))
                                    Text("Spoon")
                                        .font(.system(size: 16))
                                }
                                .padding()
                                .background(selectedMeasurement == "spoon" ? Color("#FB6112").opacity(0.5) : Color("#FB6112"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                            
                            Button(action: {
                                selectedMeasurement = "cup"
                            }) {
                                HStack {
                                    Text("🥛")
                                        .font(.system(size: 20))
                                    Text("Cup")
                                        .font(.system(size: 16))
                                }
                                .padding()
                                .background(selectedMeasurement == "cup" ? Color("#FB6112").opacity(0.5) : Color("#FB6112"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }
                        
                        // Serving Size Section
                        Text("Serving Size")
                            .font(.headline)
                        Stepper(value: $servingSize, in: 1...10) {
                            Text("Serving: \(servingSize)")
                        }
                        .padding(.bottom)
                        
                        // Add Ingredient Button
                        HStack {
                            Button("Cancel") {
                                showingIngredientPopup = false
                                newIngredientName = ""
                            }
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.orange)
                            .cornerRadius(8)
                            
                            Spacer()
                            
                            Button("Add Ingredient") {
                                let ingredient = Ingredient(name: newIngredientName, measurement: selectedMeasurement, servingSize: servingSize) // Update this line
                                ingredients.append(ingredient)
                                showingIngredientPopup = false
                                newIngredientName = ""
                            }
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .padding(.top)
                    }
                }
                
                // List of ingredients
                VStack(alignment: .leading) {
                    ForEach(ingredients) { ingredient in // Use ingredients instead of recipe.ingredients
                        Text("- \(ingredient.name) (\(ingredient.servingSize) \(ingredient.measurement))")
                            .padding(.horizontal)
                    }
                }
                .padding()

            }
        }
        .onAppear {
            if let recipeToEdit = recipeToEdit {
                title = recipeToEdit.title
                description = recipeToEdit.description
                ingredients = recipeToEdit.ingredients
                selectedImage = recipeToEdit.image
            }
        }
    }
}

// Struct for ingredients

struct Recipe: Identifiable, Codable { // Conform to Codable
    var id = UUID()
    var title: String
    var description: String
    var ingredients: [Ingredient]
    var imageData: Data? // Store image data instead of UIImage for Codable conformance

    // Computed property to convert Data back to UIImage
    var image: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
}

struct Ingredient: Identifiable, Codable { // Conform to Codable
    var id = UUID()
    var name: String
    var measurement: String
    var servingSize: Int
}

// View for displaying and managing individual recipe
struct RecipeDetailView: View {
    var recipe: Recipe  // Ensure this is defined
        @Binding var recipes: [Recipe]
        @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                NavigationLink(destination: AddRecipeView(recipes: $recipes, recipeToEdit: recipe)) {
                    
                    Spacer()
                                    Text("Edit ")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
                .padding(.trailing)
                
                Text(recipe.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                if let image = recipe.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(10)
                        .padding()
                } else {
                    Image("placeholder")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(10)
                        .padding()
                }
                
                
                Text(recipe.description)
                    .font(.subheadline)
                    .padding(.horizontal)
                Spacer()

               
                    Text("Ingredients")
                    .font(.custom("SF Pro", size: 22)).bold()
                        .padding(.horizontal)
                HStack{
                    Spacer()
                    ForEach(recipe.ingredients) { ingredient in
                        Text("- \(ingredient.name) (\(ingredient.servingSize) \(ingredient.measurement))")
                            .padding(.vertical)
                        
                    }
                    .padding()
                    .frame(width: 358, height: 52)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .foregroundColor(.orange)
                    .padding(.bottom)
                    
                    
                }
                Spacer()
                Button("Delete Recipe") {
                    if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
                        recipes.remove(at: index)
                        saveRecipesToUserDefaults(recipes: recipes) // Save the updated recipes list
                        dismiss() // Close the detail view
                    }
                }
                .padding()
                .frame(width: 387, height: 52)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.red)
                .padding(.bottom)
            }
            
        }
    }
}

// Helper functions for saving and loading recipes from UserDefaults
func saveRecipesToUserDefaults(recipes: [Recipe]) {
    if let encodedData = try? JSONEncoder().encode(recipes) {
        UserDefaults.standard.set(encodedData, forKey: "recipes")
    }
}

func loadRecipesFromUserDefaults() -> [Recipe] {
    if let data = UserDefaults.standard.data(forKey: "recipes"),
       let decodedRecipes = try? JSONDecoder().decode([Recipe].self, from: data) {
        return decodedRecipes
    }
    return []
}

// Preview provider for SwiftUI previews
struct FirstPage_Previews: PreviewProvider {
    static var previews: some View {
        FirstPage()
    }
}
