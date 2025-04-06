//
//  ContentView.swift
//  shopping_list
//
//  Created by Heesu Cho on 2025-02-27.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            LoginView()
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
