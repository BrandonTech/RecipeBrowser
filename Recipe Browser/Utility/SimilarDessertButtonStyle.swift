//
//  SimilarDessertButtonStyle.swift
//  Recipe Browser
//
//  Created by Brandon Jadotte on 11/15/23.
//

import Foundation
import SwiftUI

struct SimilarDessertButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 150)
            .padding()
            .foregroundColor(.white)
            .background(Color.accentColor.opacity(configuration.isPressed ? 0.5 : 1.0))
            .cornerRadius(10)
            .minimumScaleFactor(0.75)
    }
}
