//
//  SuggestedDessertView.swift
//  Recipe Browser
//
//  Created by Brandon Jadotte on 11/14/23.
//

import SwiftUI

struct SuggestedDessertView: View {

    var name = ""
    var image = ""
    var id: String

    var body: some View {
        NavigationLink(destination: DessertDetailView(mealID: id, presentSuggestedDessertView: false)) {
            VStack {
                AsyncImage(url: URL(string: image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                } placeholder: {
                    SwiftUI.Image(systemName: "fork.knife")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                }
                .padding(.bottom, 5)

                Text(name)
                    .fontWeight(.medium)
            }
        }
    }
}

#Preview {
    SuggestedDessertView(id: "52855")
}
