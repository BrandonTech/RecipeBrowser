//
//  DessertListView.swift
//  Recipe Browser
//
//  Created by Brandon Jadotte on 11/10/23.
//

import SwiftUI

struct DessertListView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var errorMessage: String?
    @State private var showAlert = false
    @State private var searchText = ""

    var body: some View {
        List {
            ForEach(searchResults, id: \.strMeal) { dessert in
                NavigationLink(destination: DessertDetailView(mealID: dessert.idMeal, similarMealID: getRandomMealID(excluding: dessert.idMeal)))
                {
                    DessertRowView(name: dessert.strMeal,
                                   thumbnail: dessert.strMealThumb)
                }
            }
        }
        .searchable(text: $searchText)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage ?? "An error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
        .task {
            do {
                try await viewModel.fetchDesserts()
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
    }

        // Returns a list of all desserts pulled from API if search bar is empty or returns desserts matching the text in the search bar
    var searchResults: [Dessert] {
        if searchText.isEmpty {
            return viewModel.dessertResults
        } else {
            return viewModel.dessertResults.filter { $0.strMeal.contains(searchText) }
        }
    }

        // Method to fetch a random mealID, excluding the mealID used in DessertDetailView
    func getRandomMealID(excluding excludedID: String?) -> String? {
        let availableDesserts = viewModel.dessertResults.filter { $0.idMeal != excludedID }
        return availableDesserts.randomElement()?.idMeal
    }
}

#Preview {
    DessertListView()
}
