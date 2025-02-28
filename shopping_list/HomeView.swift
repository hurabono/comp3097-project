//
//  HomeView.swift
//  shopping_list
//
//  Created by Heesu Cho on 2025-02-27.
//

import SwiftUI

struct HomeView: View {
    @State private var folders: [String] = []
    @State private var newFolderName: String = ""
    @State private var selectedFolder: String? = nil

    var body: some View {
        NavigationView {
            VStack {
                Text("Shopping")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)

                Spacer()

                // List of Folders
                if folders.isEmpty {
                    Text("No Folder now")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .padding(.top, 20)
                } else {
                    List {
                        ForEach(folders, id: \.self) { folder in
                            NavigationLink(destination: ShoppingListView(folderName: folder)) {
                                Text(folder)
                                    .font(.headline)
                            }
                        }
                        .onDelete(perform: removeFolder)
                    }
                }

                // Folder Creation Section
                VStack {
                    TextField("Enter Folder Name", text: $newFolderName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 24)

                    Button(action: {
                        addFolder()
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Folder")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                }

                Spacer()
            }
        }
        .onAppear {
            loadFolders()
        }
    }

    // Add a new folder
    func addFolder() {
        if !newFolderName.isEmpty {
            folders.append(newFolderName)
            saveFolders()
            newFolderName = ""  // Clear input field
        }
    }

    // Remove folder
    func removeFolder(at offsets: IndexSet) {
        folders.remove(atOffsets: offsets)
        saveFolders()
    }

    // Save folders to UserDefaults
    func saveFolders() {
        UserDefaults.standard.set(folders, forKey: "shoppingFolders")
    }

    // Load folders from UserDefaults
    func loadFolders() {
        if let savedFolders = UserDefaults.standard.array(forKey: "shoppingFolders") as? [String] {
            folders = savedFolders
        }
    }
}

#Preview {
    HomeView()
}

