
//
//  ShoppingListView.swift
//  shopping_list
//
//  Created by Heesu Cho on 2025-02-27.


import SwiftUI

struct ShoppingListView: View {
    let folderName: String  // HomeView에서 전달된 폴더명 (저장 키에 사용)
    @Environment(\.presentationMode) var presentationMode
    
    @State private var categories: [CategoryModel] = []
    
    // 카테고리 추가/수정용 상태
    @State private var isShowingAddCategorySheet = false
    @State private var newCategoryName = ""
    
    @State private var isShowingEditCategorySheet = false
    @State private var editCategoryIndex: Int? = nil
    @State private var editCategoryName = ""
    
    // 항목 추가용 상태 (어느 카테고리에 추가할지)
    @State private var isShowingAddItemSheet = false
    @State private var addItemCategoryIndex: Int? = nil
    
    // 하단 네비게이션 선택 (0=Home, 1=List, 2=Settings)
    @State private var selectedTab: Int = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.white, Color(red: 0.8, green: 0.88, blue: 0.97)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    topBar
                    Spacer()
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(categories.indices, id: \.self) { i in
                                categorySection(i: i)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                    }
                    Spacer()
                    customTabBar
                }
            }
            .navigationBarHidden(true)
            .onAppear { loadCategories() }
            // 카테고리 추가 모달
            .sheet(isPresented: $isShowingAddCategorySheet) { addCategorySheet }
            // 카테고리 수정 모달
            .sheet(isPresented: $isShowingEditCategorySheet) { editCategorySheet }
            // 항목 추가 모달
            .sheet(isPresented: $isShowingAddItemSheet) {
                let idx = addItemCategoryIndex ?? 0
                if idx < categories.count {
                    AddItemSheet { name, price, cat in
                        let newItem = ShoppingItem(name: name, price: price, category: cat)
                        categories[idx].items.append(newItem)
                        saveCategories()
                    }
                } else {
                    AddItemSheet { name, price, cat in
                        let newItem = ShoppingItem(name: name, price: price, category: cat)
                        categories[0].items.append(newItem)
                        saveCategories()
                    }
                }
            }
        }
    }
    
    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.title)
                    .padding()
            }
            Spacer()
            Text("\(folderName) List")
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .fontWeight(.bold)
            Spacer()
            Button {
                isShowingAddCategorySheet = true
            } label: {
                Text("+ Category")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 16)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Category Section
    private func categorySection(i: Int) -> some View {
        let cat = categories[i]
        return VStack(spacing: 0) {
            // 카테고리 바
            HStack {
                Text(cat.name)
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
                Menu {
                    Button(role: .destructive) { deleteCategory(i) } label: { Text("Delete Category") }
                    Button { startEditingCategory(i) } label: { Text("Edit Category") }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                }
                Button {
                    categories[i].isExpanded.toggle()
                    saveCategories()
                } label: {
                    Image(systemName: cat.isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(.white)
                    .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
            )
            
            if cat.isExpanded {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.white)
                        .shadow(color: .gray.opacity(0.15), radius: 3, x: 0, y: 2)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Title")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.bottom,12)
                            Spacer()
                            Text("Price")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        Divider()
                        ForEach(cat.items.indices, id: \.self) { j in
                            Divider()
                            itemRow(categoryIndex: i, itemIndex: j)
                        }
                        Divider()
                        VStack(alignment: .leading, spacing: 4) {
                            Text("• Total Taxes : $\(cat.totalTax, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("• Total Price : $\(cat.totalPrice, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 8)
                        .padding(.horizontal, 16)
                        Button {
                            addItemCategoryIndex = i
                            isShowingAddItemSheet = true
                        } label: {
                            HStack {
                                Spacer()
                                Text("Add New Item")
                                    .foregroundColor(.gray)
                                Spacer()
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                        }
                        .padding(.bottom, 8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
    }
    
    // MARK: - Item Row
    private func itemRow(categoryIndex i: Int, itemIndex j: Int) -> some View {
        let item = categories[i].items[j]
        return HStack(alignment: .top, spacing: 8) {
            Button {
                // 선택 상태 토글 구현 가능
            } label: {
                ZStack {
                    Circle()
                        .stroke(Color.gray, lineWidth: 2)
                
                        .frame(width: 18, height: 18)
                }
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text("Category: \(item.category)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "$%.2f", item.price))
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text("Tax: $\(item.taxAmount, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.red)
                Text("Total: $\(item.totalPrice, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            Button {
                removeItem(categoryIndex: i, itemIndex: j)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .padding(.leading, 4)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
    }
    
    // MARK: - Bottom Navigation
    private var customTabBar: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: -2)
                .frame(height: 80)
                .padding(.horizontal, 16)
            HStack {
                Button {
                    selectedTab = 0
                } label: {
                    VStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(selectedTab == 0 ? Color(red: 0.54, green: 0.73, blue: 0.91) : .gray)
                        Text("Home")
                            .font(.caption2)
                            .foregroundColor(selectedTab == 0 ? Color(red: 0.54, green: 0.73, blue: 0.91) : .gray)
                    }
                }
                Spacer()
                Button {
                    selectedTab = 1
                } label: {
                    VStack {
                        Image(systemName: "list.bullet")
                            .foregroundColor(selectedTab == 1 ? Color(red: 0.54, green: 0.73, blue: 0.91) : .gray)
                        Text("List")
                            .font(.caption2)
                            .foregroundColor(selectedTab == 1 ? Color(red: 0.54, green: 0.73, blue: 0.91) : .gray)
                    }
                }
                Spacer()
                Button {
                    selectedTab = 2
                } label: {
                    VStack {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(selectedTab == 2 ? Color(red: 0.54, green: 0.73, blue: 0.91) : .gray)
                        Text("Settings")
                            .font(.caption2)
                            .foregroundColor(selectedTab == 2 ? Color(red: 0.54, green: 0.73, blue: 0.91) : .gray)
                    }
                }
            }
            .padding(.horizontal, 40)
        }
        .padding(.bottom, 10)
    }
    
    // MARK: - Category Actions
    private func startEditingCategory(_ i: Int) {
        guard i < categories.count else { return }
        editCategoryIndex = i
        editCategoryName = categories[i].name
        isShowingEditCategorySheet = true
    }
    
    private func deleteCategory(_ i: Int) {
        guard i < categories.count else { return }
        categories.remove(at: i)
        saveCategories()
    }
    
    // MARK: - Item Actions
    private func removeItem(categoryIndex i: Int, itemIndex j: Int) {
        guard i < categories.count, j < categories[i].items.count else { return }
        categories[i].items.remove(at: j)
        saveCategories()
    }
    
    // MARK: - Persistence
    private func saveCategories() {
        do {
            let encoded = try JSONEncoder().encode(categories)
            UserDefaults.standard.set(encoded, forKey: "shoppingCategories_\(folderName)")
        } catch {
            print("Error saving categories: \(error)")
        }
    }
    
    private func loadCategories() {
        guard let data = UserDefaults.standard.data(forKey: "shoppingCategories_\(folderName)") else { return }
        do {
            let decoded = try JSONDecoder().decode([CategoryModel].self, from: data)
            categories = decoded
        } catch {
            print("Error loading categories: \(error)")
        }
    }
    
    // MARK: - Add Category Sheet View
    private var addCategorySheet: some View {
        VStack {
            Text("Add Category")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top, 20)
            Spacer()
            TextField("Category Name", text: $newCategoryName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 24)
            Button {
                guard !newCategoryName.isEmpty else { return }
                let newCat = CategoryModel(name: newCategoryName)
                categories.append(newCat)
                saveCategories()
                newCategoryName = ""
                isShowingAddCategorySheet = false
            } label: {
                Text("Add Category")
                    .font(.headline)
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
        .presentationDetents([.height(300)])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Edit Category Sheet View
    private var editCategorySheet: some View {
        VStack {
            Text("Edit Category")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top, 20)
            Spacer()
            TextField("New Category Name", text: $editCategoryName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 24)
            Button {
                guard let idx = editCategoryIndex, idx < categories.count, !editCategoryName.isEmpty else { return }
                categories[idx].name = editCategoryName
                saveCategories()
                editCategoryName = ""
                editCategoryIndex = nil
                isShowingEditCategorySheet = false
            } label: {
                Text("Save")
                    .font(.headline)
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
        .presentationDetents([.height(300)])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Add Item Sheet View

struct AddItemSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var itemName: String = ""
    @State private var itemPrice: String = ""
    @State private var itemCategory: String = "Food"
    
    let possibleCategories = ["Food", "Medication", "Cleaning", "Other"]
    let onAdd: (String, Double, String) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Add New Item")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top, 20)
            Spacer()
            VStack(alignment: .leading, spacing: 4) {
                Text("Item Name")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Enter name", text: $itemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal, 24)
            VStack(alignment: .leading, spacing: 4) {
                Text("Price")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Enter price", text: $itemPrice)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
            VStack(alignment: .leading, spacing: 4) {
                Text("Category")
                    .font(.caption)
                    .foregroundColor(.gray)
                Picker("Select Category", selection: $itemCategory) {
                    ForEach(possibleCategories, id: \.self) { cat in
                        Text(cat)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
            Button {
                guard !itemName.isEmpty, let priceVal = Double(itemPrice) else { return }
                onAdd(itemName, priceVal, itemCategory)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Add Item")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            Spacer()
        }
        .presentationDetents([.height(350)])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Preview

#Preview {
    ShoppingListView(folderName: "Grocery Folder")
}



