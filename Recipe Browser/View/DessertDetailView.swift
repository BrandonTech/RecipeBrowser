//
//  DessertDetailView.swift
//  Recipe Browser
//
//  Created by Brandon Jadotte on 11/7/23.
//

import SwiftUI

struct DessertDetailView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var dessertDetails: Dessert?
    @State private var similarDessertDetails: Dessert?
    @State private var errorMessage: String?
    @State private var showAlert = false

    var mealID = ""
    var presentSuggestedDessertView = true
    var similarMealID: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .center) {

                if let dessertDetails {
                    AsyncImage(url: URL(string: dessertDetails.strMealThumb)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                    } placeholder: {
                        SwiftUI.Image(systemName: "fork.knife")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                    }

                    Text(dessertDetails.strMeal)
                        .font(.largeTitle).fontWeight(.medium)
                        .padding(.top, 5)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)

                    Divider()
                        .padding(.bottom)

                    Text("Ingredients")
                        .font(.title)
                        .padding(.bottom, 5)

                    let ingredientsPairs = dessertDetails.ingredientsAndMeasurements.map { key, value in
                        "\(key) \(value)"
                    }.joined(separator: "\n")

                    Text(ingredientsPairs)
                        .padding(.bottom)

                    Text("Instructions")
                        .font(.title)
                        .padding(.top)
                        .padding(.bottom, 5)

                    Text(dessertDetails.strInstructions ?? "")
                        .padding([.leading,.trailing,.bottom])

                        // Displays SuggestedDessertView to user if it is not currently presented
                    if presentSuggestedDessertView {
                        Text("You might also like")
                            .font(.title3).fontWeight(.semibold)
                            .padding(.top)
                            .padding(.bottom, 10)

                        if let similarDessert = similarDessertDetails {
                            SuggestedDessertView(name: similarDessert.strMeal, image: similarDessert.strMealThumb, id: similarDessert.idMeal)
                                .buttonStyle(SimilarDessertButtonStyle())
                        }
                    }
                }
            }
            .toolbar {
                    // Displays a share button if dessert has a source link
                if let sourceLink = dessertDetails?.strSource {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ShareLink(item: sourceLink)
                    }
                }
            }
            .task {
                do {
                    try await dessertDetails = viewModel.fetchDessertDetails(with: mealID)

                    if let similarMealID = similarMealID {
                        try await similarDessertDetails =  viewModel.fetchDessertDetails(with: similarMealID)
                    }
                } catch DessertError.invalidData {
                    errorMessage = "Invalid data received. Please try again later."
                    showAlert = true
                } catch DessertError.invalidURL {
                    errorMessage = "Invalid URL. Please try again later."
                    showAlert = true
                } catch DessertError.invalidResponse {
                    errorMessage = "Unable to load data. Please check your connection and try again."
                    showAlert = true
                } catch {
                    errorMessage = "An unexpected error occurred. Please try again later."
                    showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage ?? "An error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    DessertDetailView()
}
