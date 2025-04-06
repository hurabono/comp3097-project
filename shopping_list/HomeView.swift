
//
//  HomeView.swift
//  shopping_list
//
//  Created by Heesu Cho on 2025-02-27.
//

import SwiftUI

// MARK: - Folder Model
struct Folder: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var itemCount: Int

    init(id: UUID = UUID(), name: String, description: String, itemCount: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.itemCount = itemCount
    }
}

struct HomeView: View {
    @State private var folders: [Folder] = []

    @State private var isShowingAddFolderSheet = false
    @State private var isShowingEditFolderSheet = false

    @State private var newFolderName: String = ""
    @State private var newFolderDescription: String = ""

    @State private var editFolder: Folder? = nil
    @State private var editFolderName: String = ""
    @State private var editFolderDescription: String = ""

    @State private var folderForOptions: Folder? = nil
    @State private var isShowingFolderOptions = false

    // 하단 탭 (0=Home, 1=List, 2=Settings)
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationView {
            ZStack {
                // 배경 그라디언트
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(red: 0.8, green: 0.88, blue: 0.97)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    topBar

                    Spacer()

                    // 탭별 화면 전환
                    if selectedTab == 0 {
                        homeTabView
                    } else if selectedTab == 1 {
                        // LIST 탭 → AllCategoriesView (필요 시 교체)
                        AllCategoriesView()
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                    } else {
                        // SETTINGS 탭 → SettingsView
                        SettingsView()
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                    }

                    Spacer()

                    // 하단 탭 바
                    customTabBar
                }

                // + 버튼
                if selectedTab == 0 || selectedTab == 1 {
                    plusFloatingButton
                }
            }
            // 전체적으로 iOS 기본 상단 바 숨김
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        // 폴더 로드
        .onAppear {
            loadFolders()
        }
        // Folder Add/Edit
        .sheet(isPresented: $isShowingAddFolderSheet) {
            addFolderSheet
        }
        .sheet(isPresented: $isShowingEditFolderSheet) {
            editFolderSheet
        }
        .confirmationDialog("Folder Options", isPresented: $isShowingFolderOptions) {
            if let folder = folderForOptions {
                Button("Delete", role: .destructive) {
                    deleteFolder(folder)
                }
                Button("Edit") {
                    startEditingFolder(folder)
                }
            }
        } message: {
            Text(folderForOptions?.name ?? "")
        }
    }

    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            

            Spacer()

            // 중앙 로고
            HStack(spacing: 2) {
                Text("E")
                    .foregroundColor(Color(red: 0.54, green: 0.73, blue: 0.91))
                    .font(.system(size: 28, weight: .bold))
                Text("Z list")
                    .foregroundColor(.gray)
                    .font(.system(size: 28, weight: .regular))
            }

            Spacer()
            Spacer().frame(width: 5)
        }
        .padding(.horizontal, 20)
        .padding(.top, 50)
        .padding(.bottom, 20)
    }

    // MARK: - Home Tab
    private var homeTabView: some View {
        VStack {
            if folders.isEmpty {
                Image(systemName: "list.bullet.rectangle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color(red: 0.54, green: 0.73, blue: 0.91))

                Text("No Folder now")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 8)

                Text("Add a new folder for list")
                    .font(.subheadline)
                    .foregroundColor(.gray.opacity(0.8))
                    .padding(.top, 2)
            } else {
                ScrollView {
                    let columns = [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(folders) { folder in
                            // 폴더 클릭 → 해당 ShoppingListView로
                            NavigationLink(destination:
                                ShoppingListView(folderName: folder.name)
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                            ) {
                                folderCard(folder: folder)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    // MARK: - Bottom Tab Bar
    private var customTabBar: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: -2)
                .frame(height: 80)
                .padding(.horizontal, 16)

            HStack {
                // HOME
                Button {
                    selectedTab = 0
                } label: {
                    VStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(selectedTab == 0
                                             ? Color(red: 0.54, green: 0.73, blue: 0.91)
                                             : .gray)
                        Text("Home")
                            .font(.caption2)
                            .foregroundColor(selectedTab == 0
                                             ? Color(red: 0.54, green: 0.73, blue: 0.91)
                                             : .gray)
                    }
                }
                Spacer()

                // LIST
                Button {
                    selectedTab = 1
                } label: {
                    VStack {
                        Image(systemName: "list.bullet")
                            .foregroundColor(selectedTab == 1
                                             ? Color(red: 0.54, green: 0.73, blue: 0.91)
                                             : .gray)
                        Text("List")
                            .font(.caption2)
                            .foregroundColor(selectedTab == 1
                                             ? Color(red: 0.54, green: 0.73, blue: 0.91)
                                             : .gray)
                    }
                }
                Spacer()

                // SETTINGS
                Button {
                    selectedTab = 2
                } label: {
                    VStack {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(selectedTab == 2
                                             ? Color(red: 0.54, green: 0.73, blue: 0.91)
                                             : .gray)
                        Text("Settings")
                            .font(.caption2)
                            .foregroundColor(selectedTab == 2
                                             ? Color(red: 0.54, green: 0.73, blue: 0.91)
                                             : .gray)
                    }
                }
            }
            .padding(.horizontal, 40)
        }
        .padding(.bottom, 10)
    }

    // MARK: - + Folder Floating Button
    private var plusFloatingButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.white)
                        .frame(width: 140, height: 50)
                        .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)

                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(Color(red: 0.54, green: 0.73, blue: 0.91))
                        Text("Add Folder")
                            .foregroundColor(.gray)
                    }
                }
                .onTapGesture {
                    isShowingAddFolderSheet = true
                }
                .padding(.trailing, 30)
                .padding(.bottom, 120)
            }
        }
    }

    // MARK: - Folder Card
    private func folderCard(folder: Folder) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white)
                .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Spacer()
                    Button {
                        folderForOptions = folder
                        isShowingFolderOptions = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 8)
                .padding(.trailing, 8)

                Text(folder.name)
                    .font(.headline)
                    .foregroundColor(Color(red: 0.54, green: 0.73, blue: 0.91))

                Text(folder.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()

                Text("\(folder.itemCount) Item\(folder.itemCount > 1 ? "s" : "")")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
            }
            .padding(.horizontal, 8)
            .frame(height: 180)
        }
    }

    // MARK: - Add Folder Sheet
    private var addFolderSheet: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Text("Folder Name")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Title")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("", text: $newFolderName)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Description")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("", text: $newFolderDescription)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Button {
                    addFolder()
                    isShowingAddFolderSheet = false
                } label: {
                    Text("Add Folder")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 0.54, green: 0.73, blue: 0.91))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                Spacer()
            }

            Button {
                isShowingAddFolderSheet = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
                    .padding(10)
            }
        }
    }

    // MARK: - Edit Folder Sheet
    private var editFolderSheet: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Text("Edit Folder")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Title")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("", text: $editFolderName)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Description")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("", text: $editFolderDescription)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Button {
                    saveEditFolder()
                    isShowingEditFolderSheet = false
                } label: {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 0.54, green: 0.73, blue: 0.91))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                Spacer()
            }

            Button {
                isShowingEditFolderSheet = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
                    .padding(10)
            }
        }
    }

    // MARK: - Folder Logic
    private func addFolder() {
        guard !newFolderName.isEmpty else { return }
        let folder = Folder(name: newFolderName,
                            description: newFolderDescription,
                            itemCount: 1)
        folders.append(folder)
        saveFolders()

        newFolderName = ""
        newFolderDescription = ""
    }

    private func deleteFolder(_ folder: Folder) {
        folders.removeAll { $0.id == folder.id }
        saveFolders()
    }

    private func startEditingFolder(_ folder: Folder) {
        editFolder = folder
        editFolderName = folder.name
        editFolderDescription = folder.description
    }

    private func saveEditFolder() {
        guard let target = editFolder else { return }
        if let idx = folders.firstIndex(where: { $0.id == target.id }) {
            folders[idx].name = editFolderName
            folders[idx].description = editFolderDescription
        }
        saveFolders()
        editFolder = nil
        editFolderName = ""
        editFolderDescription = ""
    }

    private func saveFolders() {
        if let encoded = try? JSONEncoder().encode(folders) {
            UserDefaults.standard.set(encoded, forKey: "shoppingFolders")
        }
    }

    private func loadFolders() {
        guard let data = UserDefaults.standard.data(forKey: "shoppingFolders") else { return }
        if let decoded = try? JSONDecoder().decode([Folder].self, from: data) {
            folders = decoded
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
