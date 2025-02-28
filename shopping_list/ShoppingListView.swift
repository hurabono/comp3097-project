//
//  ShoppingListView.swift
//  shopping_list
//
//  Created by Heesu Cho on 2025-02-27.
//

import SwiftUI

struct ShoppingListView: View {
    var folderName: String  // Accepts folder name to keep lists separate
    @Environment(\.presentationMode) var presentationMode
    @State private var items: [ShoppingItem] = []
    @State private var newItemName: String = ""
    @State private var newItemPrice: String = ""
    @State private var selectedCategory: String = "Food"

    let categories = ["Food", "Medication", "Cleaning", "Other"]

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .padding()
                    }
                    Spacer()
                    Text("\(folderName) List")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)

                // List of Items
                List {
                    ForEach(items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text("Category: \(item.category)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("$\(item.price, specifier: "%.2f")")
                                    .fontWeight(.bold)
                                Text("Tax: $\(item.taxAmount, specifier: "%.2f")")
                                    .foregroundColor(.red)
                                Text("Total: $\(item.totalPrice, specifier: "%.2f")")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .onDelete(perform: removeItem)
                }

                // Input Fields for New Item
                TextField("Enter Item Name", text: $newItemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)

                TextField("Enter Price", text: $newItemPrice)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .padding(.horizontal, 24)

                // Category Picker
                Picker("Select Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 24)

                // Add Item Button
                Button(action: {
                    addItem()
                }) {
                    Text("Add Item")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)

                Spacer()
            }
        }
        .onAppear {
            loadItems()
        }
    }

    // Add new item to the list
    func addItem() {
        guard let price = Double(newItemPrice), !newItemName.isEmpty else {
            return
        }

        let newItem = ShoppingItem(name: newItemName, price: price, category: selectedCategory)
        items.append(newItem)
        saveItems()

        // Clear input fields after adding
        newItemName = ""
        newItemPrice = ""
        selectedCategory = "Food"
    }

    // Remove item from list
    func removeItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        saveItems()
    }

    // Save items to UserDefaults for each folder separately
    func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "shoppingList_\(folderName)")
        }
    }

    // Load items for each folder separately
    func loadItems() {
        if let savedItems = UserDefaults.standard.data(forKey: "shoppingList_\(folderName)"),
           let decodedItems = try? JSONDecoder().decode([ShoppingItem].self, from: savedItems) {
            items = decodedItems
        }
    }
}

#Preview {
    ShoppingListView(folderName: "Test Folder")
}


