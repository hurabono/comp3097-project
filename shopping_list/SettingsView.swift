//
//  SettingsView.swift
//  shopping_list
//
//  Created by Heesu Cho on 2025-02-27.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode  // Allows back navigation

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()  // Go back to Home
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .padding()
                    }
                    Spacer()
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)

                List {
                    NavigationLink(destination: Text("Account Settings")) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.blue)
                            Text("Account")
                        }
                    }

                    NavigationLink(destination: Text("Help & Feedback")) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Help and Feedback")
                        }
                    }

                    NavigationLink(destination: Text("Canadian Grocery Tax Guide")) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.orange)
                            Text("Canadian Grocery Tax Guide")
                        }
                    }

                    Button(action: {
                        print("Logout pressed")
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.square.fill")
                                .foregroundColor(.red)
                            Text("Log out")
                        }
                    }
                }

                Spacer()
            }
        }
    }
}

#Preview {
    SettingsView()
}

