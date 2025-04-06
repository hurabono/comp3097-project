import SwiftUI

struct SettingsView: View {
    @State private var userEmail: String = ""
    @State private var isLoggedOut: Bool = false  // 로그아웃 시점 제어 (LoginView 보여주기)

    var body: some View {
        NavigationView {
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
                    topBar

                    Spacer()

                    // 로그인된 이메일 표시
                    Text("Logged in as \(userEmail)")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 40)

                    Spacer()

                    // 로그아웃 버튼
                    Button {
                        logout()
                    } label: {
                        Text("Log Out")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 60)
                }
            }
            // iOS 상단바 숨김
            .navigationBarHidden(true)
        }
        // View가 나타날 때 로그인 이메일 불러옴
        .onAppear {
            loadUserEmail()
        }
        // 로그아웃 → LoginView로 전환
        .fullScreenCover(isPresented: $isLoggedOut) {
            LoginView().navigationBarHidden(true)
        }
    }

    // MARK: - Top Bar
    private var topBar: some View {
        HStack {

            Spacer()
            Spacer().frame(width: 40)
        }
        .padding(.horizontal, 16)
        .padding(.top, 50)
        .padding(.bottom, 20)
    }

    // MARK: - Load Email
    private func loadUserEmail() {
        // 로그인 시 저장했던 키
        userEmail = UserDefaults.standard.string(forKey: "loggedInEmail") ?? "No Email"
    }

    // MARK: - Logout
    private func logout() {
        // UserDefaults에서 email 제거 (또는 토큰 등)
        UserDefaults.standard.removeObject(forKey: "loggedInEmail")

        // 로그아웃 상태
        isLoggedOut = true
    }
}

#Preview {
    SettingsView()
}
