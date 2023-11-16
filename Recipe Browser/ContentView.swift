//
//  ContentView.swift
//  Recipe Browser
//
//  Created by Brandon Jadotte on 11/7/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            DessertListView()
                .navigationTitle("Desserts")
        }
    }
}

#Preview {
    ContentView()
}
