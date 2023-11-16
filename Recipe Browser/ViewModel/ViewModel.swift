//
//  ViewModel.swift
//  Recipe Browser
//
//  Created by Brandon Jadotte on 11/9/23.
//

import Foundation

class ViewModel: ObservableObject {

    @Published var dessertResults: [Dessert] = []

    func fetchDesserts() async throws {

        guard let endpoint = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            throw DessertError.invalidURL
        }

        let request = URLRequest(url: endpoint)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw DessertError.invalidResponse }

            guard let decodedResponse = try? JSONDecoder().decode(DessertResponse.self, from: data) else {
                throw DessertError.invalidData
            }

            Task { @MainActor in
                self.dessertResults = decodedResponse.meals
            }
        }
    }


    func fetchDessertDetails(with mealID: String) async throws -> Dessert {

        guard let detailsEndpoint = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)") else { throw DessertError.invalidURL }

        let request = URLRequest(url: detailsEndpoint)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw DessertError.invalidResponse }

            guard let dessertResponse = try? JSONDecoder().decode(DessertResponse.self, from: data),
                  let selectedDessert = dessertResponse.meals.first
            else {
                throw DessertError.invalidData
            }
            return selectedDessert
        }
    }
}
