//
//  ForgotPasswordView.swift
//  shopping_list
//
//  Created by Heesu Cho on 2025-02-27.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""

    var body: some View {
        VStack {
            // App Name
            Text("Shopping")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)

            Spacer()

            // Email Field
            TextField("Enter your email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal, 24)

            // Verify Button
            Button(action: {
                print("Verify pressed")
            }) {
                Text("Verify")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)

            Spacer()
        }
    }
}

#Preview {
    ForgotPasswordView()
}


