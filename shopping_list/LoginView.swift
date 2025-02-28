//
//  LoginView.swift
//  shopping_list
//
//  Created by Heesu Cho on 2025-02-27.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
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
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal, 24)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal, 24)

                // Navigation to Home
                NavigationLink(destination: HomeView(), isActive: $isHomeActive) {
                    EmptyView()
                }

                Button(action: {
                    validateLogin()
                }) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)

                NavigationLink(destination: SignupView()) {
                    Text("Sign Up")
                        .foregroundColor(.blue)
                }
                .padding(.top, 5)

                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func validateLogin() {
        if email.isEmpty || password.isEmpty {
            alertMessage = "Email and Password cannot be empty."
            showAlert = true
        } else {
            isHomeActive = true
        }
    }
}

#Preview {
    LoginView()
}




