//
//  DessertRowView.swift
//  Recipe Browser
//
//  Created by Brandon Jadotte on 11/7/23.
//

import SwiftUI

struct DessertRowView: View {

    let name: String
    let thumbnail: String

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: thumbnail)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 75, alignment: .leading)
            } placeholder: {
                SwiftUI.Image(systemName: "fork.knife")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 75, alignment: .leading)
            }

            Text(name)
                .padding(.leading)
        }
    }
}

#Preview {
    DessertRowView(name: "Apam balik", thumbnail: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
}
