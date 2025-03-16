

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false  // Password show
    @State private var isHomeActive = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                // Gradient View
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(red: 0.78, green: 0.9, blue: 0.97)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack {
                    // Top padding
                    Spacer().frame(height: 130)

                    // "EZ list" Logo
                    HStack(spacing: 0) {
                        Text("E")
                            .foregroundColor(Color(red: 0.54, green: 0.73, blue: 0.91)) //Blue light Design form
                            .font(.system(size: 42, weight: .semibold))
                        Text("Z list")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 42, weight: .regular))
                    }
                    .padding(.bottom, 40)

                    // Email Input
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Email")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.leading, 8)

                        TextField("", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.clear, lineWidth: 1)
                            )
                            .shadow(color: Color.gray.opacity(0.2), radius: 3, x: 0, y: 2)
                    }
                    .padding(.horizontal, 24)

                    // Password Input
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Password")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.leading, 8)

                        HStack {
                            if showPassword {
                                TextField("", text: $password)
                                    .autocapitalization(.none)
                            } else {
                                SecureField("", text: $password)
                                    .autocapitalization(.none)
                            }
                            // Eyefill icons
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 16)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.clear, lineWidth: 1)
                        )
                        .shadow(color: Color.gray.opacity(0.2), radius: 3, x: 0, y: 2)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)

                    // Forgot password?
                    Button(action: {
                        // Pasword Recovered Logic
                        // Code here
                        
                    }) {
                        Text("Forget password?")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .underline()
                    }
                    .padding(.top, 8)

                    // log in home view
                    NavigationLink(destination: HomeView(), isActive: $isHomeActive) {
                        EmptyView()
                    }

                    // Log In button Design
                    Button(action: {
                        validateLogin()
                    }) {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.58, green: 0.78, blue: 0.96)) // Keep light blue button pelase
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)

                    // Sign Up Button
                    NavigationLink(destination: SignupView()) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.58, green: 0.78, blue: 0.96))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color(red: 0.58, green: 0.78, blue: 0.96), lineWidth: 2)
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)

                    Spacer()
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Login Failed "),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("Ok"))
                    )
                }
            }
        }
    }

    func validateLogin() {
        // Login Validation Sample
        if email == "test@test.com" && password == "1234" {
            isHomeActive = true
        } else {
            alertMessage = "Incorrect Password"
            showAlert = true
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}



