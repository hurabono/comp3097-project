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
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var isHomeActive = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
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
                    Spacer().frame(height: 100)
                    
                    HStack(spacing: 0) {
                        Text("Sign")
                            .foregroundColor(Color(red: 0.54, green: 0.73, blue: 0.91))
                            .font(.system(size: 42, weight: .semibold))
                        Text(" Up")
                            .foregroundColor(.gray)
                            .font(.system(size: 42, weight: .regular))
                    }
                    .padding(.bottom, 30)
                    
                    Group {
                        // Email
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
                                .shadow(color: Color.gray.opacity(0.2), radius: 3, x: 0, y: 2)
                        }
                        .padding(.horizontal, 24)
                        
                        // Password
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
                            .shadow(color: Color.gray.opacity(0.2), radius: 3, x: 0, y: 2)
                        }
                        .padding(.horizontal, 24)
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Confirm Password")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                            
                            HStack {
                                if showConfirmPassword {
                                    TextField("", text: $confirmPassword)
                                        .autocapitalization(.none)
                                } else {
                                    SecureField("", text: $confirmPassword)
                                        .autocapitalization(.none)
                                }
                                
                                Button(action: {
                                    showConfirmPassword.toggle()
                                }) {
                                    Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing, 16)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(color: Color.gray.opacity(0.2), radius: 3, x: 0, y: 2)
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    NavigationLink(destination: HomeView(), isActive: $isHomeActive) {
                        EmptyView()
                    }
                    
                    Button(action: {
                        validateSignup()
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.58, green: 0.78, blue: 0.96))
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Already have an account? Log In")
                            .foregroundColor(Color.gray)
                            .underline()
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarBackButtonHidden(true) // <- add ONLY THIS LINE
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
            // Save the email and password to UserDefaults
            UserDefaults.standard.set(email, forKey: "registeredEmail")
            UserDefaults.standard.set(password, forKey: "registeredPassword")
            
            isHomeActive = true
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
