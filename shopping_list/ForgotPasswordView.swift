import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isEmailMatched: Bool = false
    @State private var errorMessage: String = ""
    @State private var successMessage: String = ""
    @State private var navigateToLogin: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.white, Color(red: 0.8, green: 0.88, blue: 0.97)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    // 중앙 로고
                    HStack(spacing: 0) {
                        Text("E")
                            .foregroundColor(Color(red: 0.54, green: 0.73, blue: 0.91))
                            .font(.system(size: 36, weight: .bold))
                        Text("Z list")
                            .foregroundColor(.gray)
                            .font(.system(size: 36, weight: .regular))
                    }
                    .padding(.top, 40)

                    Spacer()

                    if !isEmailMatched {
                        VStack(spacing: 10) {
                            TextField("Enter your email", text: $email)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 2)
                                .padding(.horizontal, 24)
                                .foregroundColor(.black)

                            if !errorMessage.isEmpty {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.footnote)
                            }

                            Button(action: verifyEmail) {
                                Text("Verify")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 0.58, green: 0.78, blue: 0.96))
                                    .cornerRadius(25)
                            }
                            .padding(.horizontal, 24)
                        }
                    } else {
                        VStack(spacing: 10) {
                            SecureField("New Password", text: $newPassword)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 2)
                                .padding(.horizontal, 24)

                            SecureField("Confirm Password", text: $confirmPassword)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 2)
                                .padding(.horizontal, 24)

                            if !successMessage.isEmpty {
                                Text(successMessage)
                                    .foregroundColor(.green)
                                    .font(.footnote)
                            }

                            NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true), isActive: $navigateToLogin) {
                                EmptyView()
                            }

                            Button(action: {
                                if successMessage.isEmpty {
                                    saveNewPassword()
                                } else {
                                    navigateToLogin = true
                                }
                            }) {
                                Text(successMessage.isEmpty ? "Save Password" : "Log In")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 0.58, green: 0.78, blue: 0.96))
                                    .cornerRadius(25)
                            }
                            .padding(.horizontal, 24)
                        }
                    }

                    Spacer()

                    NavigationLink(destination: SignupView().navigationBarBackButtonHidden(true)) {
                        Text("Do you want to make account?")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .underline()
                    }
                    .padding(.bottom, 16)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func verifyEmail() {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email."
            return
        }

        if let savedEmail = UserDefaults.standard.string(forKey: "registeredEmail") {
            if savedEmail.lowercased() == email.lowercased() {
                isEmailMatched = true
                errorMessage = ""
            } else {
                errorMessage = "Email does not match our records."
            }
        } else {
            errorMessage = "No registered email found."
        }
    }

    private func saveNewPassword() {
        guard !newPassword.isEmpty && !confirmPassword.isEmpty else {
            errorMessage = "Please fill out both password fields."
            return
        }

        guard newPassword == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        UserDefaults.standard.set(newPassword, forKey: "userPassword_\(email.lowercased())")
        successMessage = "Password updated successfully."
        errorMessage = ""
        newPassword = ""
        confirmPassword = ""
    }
}

#Preview {
    ForgotPasswordView()
}
