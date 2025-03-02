//
//  SignupView.swift
//  shopping_list
//
//

import SwiftUI

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isHomeActive = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Shopping")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)

                Spacer()

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 24)

                SecureField("Password", text: $password)
                    .textContentType(.newPassword)  // Fix strong password UI issue
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)

                SecureField("Confirm Password", text: $confirmPassword)
                    .textContentType(.newPassword)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)

                // Navigation to Home
                NavigationLink(destination: HomeView(), isActive: $isHomeActive) {
                    EmptyView()
                }

                Button(action: {
                    validateSignup()
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)

                NavigationLink(destination: LoginView()) {
                    Text("Already have an account? Log In")
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)

                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func validateSignup() {
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            alertMessage = "All fields are required."
            showAlert = true
        } else if password != confirmPassword {
            alertMessage = "Passwords do not match."
            showAlert = true
        } else {
            isHomeActive = true
        }
    }
}

#Preview {
    SignupView()
}


