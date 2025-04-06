
//  ShoppingListView.swift
//  shopping_list
//
//  Created by Heesu Cho on 2025-02-27.


import SwiftUI

struct ShoppingListView: View {
    let folderName: String  // HomeView에서 전달된 폴더명
    @Environment(\.presentationMode) var presentationMode
    
    @State private var categories: [CategoryModel] = []
    
    // 카테고리 추가/편집 시트
    @State private var isShowingAddCategorySheet = false
    @State private var newCategoryName = ""
    
    @State private var isShowingEditCategorySheet = false
    @State private var editCategoryIndex: Int? = nil
    @State private var editCategoryName = ""
    
    // 아이템 추가 시트
    @State private var isShowingAddItemSheet = false
    @State private var addItemCategoryIndex: Int? = nil
    
    var body: some View {
        // ✅ NavigationView 삭제 → iOS 기본 "< back" 안 뜸
        ZStack {
            // 배경 그라디언트
            LinearGradient(
                gradient: Gradient(colors: [
                    .white,
                    Color(red: 0.8, green: 0.88, blue: 0.97)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // 상단: 커스텀 화살표 + Title
                topBar
                
                Spacer()
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(categories.indices, id: \.self) { i in
                            categorySection(i)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                }
                
                Spacer()
                // 하단 네비게이션 전부 없음
            }
        }
        // 데이터 로드
        .onAppear {
            loadCategories()
        }
        // 시트 연결
        .sheet(isPresented: $isShowingAddCategorySheet) {
            addCategorySheet
        }
        .sheet(isPresented: $isShowingEditCategorySheet) {
            editCategorySheet
        }
        .sheet(isPresented: $isShowingAddItemSheet) {
            let idx = addItemCategoryIndex ?? 0
            if idx < categories.count {
                AddItemSheet { name, price, cat in
                    let newItem = ShoppingItem(name: name, price: price, category: cat)
                    categories[idx].items.append(newItem)
                    saveCategories()
                }
            } else if !categories.isEmpty {
                AddItemSheet { name, price, cat in
                    let newItem = ShoppingItem(name: name, price: price, category: cat)
                    categories[0].items.append(newItem)
                    saveCategories()
                }
            }
        }
    }
    
    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            // 커스텀 화살표(←)
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.title)
                    .padding()
            }
            Spacer()
            
            // 중앙: "folderName List"
            Text("\(folderName) List")
                .foregroundColor(.blue)
                .fontWeight(.bold)
            
            Spacer()
            
            // 우측: "+ Category"
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
    private func categorySection(_ i: Int) -> some View {
        let cat = categories[i]
        return VStack(spacing: 0) {
            // Category Header
            HStack {
                Text(cat.name)
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
                Menu {
                    Button(role: .destructive) {
                        deleteCategory(i)
                    } label: {
                        Text("Delete Category")
                    }
                    Button {
                        startEditingCategory(i)
                    } label: {
                        Text("Edit Category")
                    }
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
            
            // 펼침
            if cat.isExpanded {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.white)
                        .shadow(color: .gray.opacity(0.15), radius: 3, x: -1, y: 2)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Title")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 12)
                            Spacer()
                            Text("Price")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
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
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
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
                // circle check
            } label: {
                ZStack {
                    Circle()
                        .stroke(Color.gray, lineWidth: 2)
                        .frame(width: 20, height: 18)
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
        .padding(.vertical, 8.0)
        .padding(.horizontal, 10)
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
    
    // MARK: - Add Category Sheet
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
    
    // MARK: - Edit Category Sheet
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

// MARK: - Add Item Sheet
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
                .padding(.top, 40)
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
            .padding(.top, 0)
            Spacer()
        }
        .presentationDetents([.height(350)])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Preview
#Preview {
    // 미리보기 → iOS 시스템 "Back" 없음, 커스텀 화살표 있음
    ShoppingListView(folderName: "SampleFolder")
}
