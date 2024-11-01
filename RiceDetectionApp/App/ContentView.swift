//
//  ContentView.swift
//  RiceDetectionApp
//
//  Created by Zachary Farmer on 10/24/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            HomeView()
        }
    }
}

#Preview {
    ContentView()
//        .modelContainer(for: Prediction.self, inMemory: true)
}
