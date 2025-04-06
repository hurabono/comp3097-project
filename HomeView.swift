//
//  HomeView.swift
//  shopping_list
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
    // Home view default value
    // MARK: - State
    // ser empty space > No folder 
    @State private var folders: [Folder] = []

    // Add Folder Sheet
    @State private var isShowingAddFolderSheet = false
    // Edit Folder Sheet
    @State private var isShowingEditFolderSheet = false

    // New folder inputs
    @State private var newFolderName: String = ""
    @State private var newFolderDescription: String = ""

    // Edit folder inputs
    @State private var editFolder: Folder? = nil
    @State private var editFolderName: String = ""
    @State private var editFolderDescription: String = ""

    // 3dots menu for each folder
    // modal delete and edit folder 
    @State private var folderForOptions: Folder? = nil
    @State private var isShowingFolderOptions = false

    // Bottom tab selection 
    // Bottom tab will imply soon for every sections
    // 0=Home, 1=List, 2=Settings
    @State private var selectedTab: Int = 0

    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [.white,
                                                Color(red: 0.8, green: 0.88, blue: 0.97)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    // Top Bar
                    topBar

                    Spacer()

                    // Tab Content
                    if selectedTab == 0 {
                        homeTabView
                    } else if selectedTab == 1 {
                        listTabView
                    } else {
                        settingsTabView
                    }

                    Spacer()

                    // Bottom Tab Bar (fully rounded corners)
                    customTabBar
                }

                // Floating + Button
                if selectedTab == 0 || selectedTab == 1 {
                    plusFloatingButton
                }
            }
            .navigationBarHidden(true)
        }
        // Load folders on appear
        .onAppear {
            loadFolders()
        }
        // Add folder sheet
        .sheet(isPresented: $isShowingAddFolderSheet) {
            addFolderSheet
                .presentationDetents([.height(330)])
                .presentationDragIndicator(.hidden)
        }
        // Edit folder sheet
        .sheet(isPresented: $isShowingEditFolderSheet) {
            editFolderSheet
                .presentationDetents([.height(330)])
                .presentationDragIndicator(.hidden)
        }
        // 3-dot menu dialog (Delete / Edit)
        .confirmationDialog(
            "Folder Options",
            isPresented: $isShowingFolderOptions
        ) {
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
            Button(action: {}) {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundColor(.gray)
            }

            Spacer()

            // App logo
            HStack(spacing: 0) {
                Text("E")
                    .foregroundColor(Color(red: 0.54, green: 0.73, blue: 0.91))
                    .font(.system(size: 28, weight: .bold))
                Text("Z list")
                    .foregroundColor(.gray)
                    .font(.system(size: 28, weight: .regular))
            }

            Spacer()
            // right spacing
            Spacer().frame(width: 40)
        }
        .padding(.horizontal, 16)
        .padding(.top, 50)
        .padding(.bottom, 20)
    }

    // MARK: - Home Tab
    private var homeTabView: some View {
        VStack {
            if folders.isEmpty {
                // 1) No folders
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
                // 2) Folders exist
                ScrollView {
                    let columns = [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(folders) { folder in
                            // Folder card → ShoppingListView
                            NavigationLink(destination: ShoppingListView(folderName: folder.name)) {
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

    // MARK: - List Tab
    private var listTabView: some View {
        Text("List Screen")
            .font(.headline)
            .foregroundColor(.gray)
    }

    // MARK: - Settings Tab
    private var settingsTabView: some View {
        Text("Settings Screen")
            .font(.headline)
            .foregroundColor(.gray)
    }

    // MARK: - Fully Rounded Bottom Tab Bar
    private var customTabBar: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16) // Round all corners
                .foregroundColor(.white)
                .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: -2)
                .frame(height: 80)
                .padding(.horizontal, 16)

            HStack {
                // Home
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

                // List
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

                // Settings
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

    // MARK: - Floating Add folder Button
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
                // 3-dot menu button
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

                // Name & description
                Text(folder.name)
                    .font(.headline)
                    .foregroundColor(Color(red: 0.54, green: 0.73, blue: 0.91))

                Text(folder.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()

                // Item count
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

                // Title
                VStack(alignment: .leading, spacing: 6) {
                    Text("Title")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("", text: $newFolderName)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Description
                VStack(alignment: .leading, spacing: 6) {
                    Text("Description")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("", text: $newFolderDescription)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Add Folder button
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

            // Close X
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

                // Title
                VStack(alignment: .leading, spacing: 6) {
                    Text("Title")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("", text: $editFolderName)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Description
                VStack(alignment: .leading, spacing: 6) {
                    Text("Description")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("", text: $editFolderDescription)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Save button
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

            // Close X
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

    // MARK: - Add Folder Logic
    private func addFolder() {
        guard !newFolderName.isEmpty else { return }
        let folder = Folder(name: newFolderName,
                            description: newFolderDescription,
                            itemCount: 1)
        folders.append(folder)
        saveFolders()

        // Reset inputs
        newFolderName = ""
        newFolderDescription = ""
    }

    // MARK: - Delete Folder
    private func deleteFolder(_ folder: Folder) {
        folders.removeAll { $0.id == folder.id }
        saveFolders()
    }

    // MARK: - Start Editing
    private func startEditingFolder(_ folder: Folder) {
        editFolder = folder
        editFolderName = folder.name
        editFolderDescription = folder.description
        isShowingEditFolderSheet = true
    }

    // MARK: - Save Edit
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

    // MARK: - Save / Load Folders
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
