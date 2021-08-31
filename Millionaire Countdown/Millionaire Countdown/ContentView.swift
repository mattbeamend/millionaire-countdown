//
//  ContentView.swift
//  Millionaire Countdown
//
//  Created by Matthew Smith on 20/07/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            // Calculator View
            CalculatorView()
                .tabItem {
                    Label("Calculator", systemImage: "square.grid.3x3")
                }
            
            
            // Dashboard View
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "speedometer")
                }
            
            // Settings View
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.2")
                }
        }
    }
}

// Preview Provider - select the IDE preview device
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 8")
    }
}
