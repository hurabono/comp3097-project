import SwiftUI

struct AllCategoriesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // 통합된 카테고리 목록
    @State private var allCategories: [CategoryModel] = []
    
    var body: some View {
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
                // 상단 바에서 화살표와 Title을 모두 삭제
                HStack {
                    Spacer() // 왼쪽 화살표 아이콘 삭제
                    Spacer()
                }
                .padding(.horizontal)

                Spacer()

                // 스크롤로 카테고리들 표시
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(allCategories.indices, id: \.self) { i in
                            categorySection(i)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                }
                Spacer()
                // ✅ 하단 네비게이션도 완전히 제거
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadAllCategories()
        }
    }

    // MARK: - categorySection
    private func categorySection(_ i: Int) -> some View {
        let cat = allCategories[i]
        return VStack(spacing: 0) {
            // 상단 카테고리 바
            HStack {
                Text(cat.name)
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
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
                        // 좀 더 크게
                        .frame(minHeight: 220)

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
                                .foregroundColor(.gray)
                            Text("• Total Price : $\(cat.totalPrice, specifier: "%.2f")")
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 8)
                        .padding(.horizontal, 16)
                        // 아래쪽 여유
                        .padding(.bottom, 20)
                    }
                }
                // 전체 높이 추가
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
        }
    }

    // MARK: - itemRow
    private func itemRow(categoryIndex i: Int, itemIndex j: Int) -> some View {
        let item = allCategories[i].items[j]
        return HStack(alignment: .top, spacing: 8) {
            Button {
                // circle check logic
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
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
    }

    // MARK: - loadAllCategories
    private func loadAllCategories() {
        allCategories = []
        guard let data = UserDefaults.standard.data(forKey: "shoppingFolders"),
              let folderList = try? JSONDecoder().decode([Folder].self, from: data)
        else { return }
        for folder in folderList {
            let catKey = "shoppingCategories_\(folder.name)"
            if let catData = UserDefaults.standard.data(forKey: catKey),
               let catArray = try? JSONDecoder().decode([CategoryModel].self, from: catData) {
                let renamed = catArray.map { c -> CategoryModel in
                    var copy = c
                    copy.name = "[\(folder.name)] " + copy.name
                    return copy
                }
                allCategories.append(contentsOf: renamed)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AllCategoriesView()
}
