import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Profile Section
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        Text("John Doe")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("john.doe@test.com")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()

                // Settings Options
                List {
                    NavigationLink(destination: Text("Account Settings")) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.blue)
                            Text("Account")
                        }
                    }
                    
                    NavigationLink(destination: Text("Help & Feedback")) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Help and Feedback")
                        }
                    }
                    
                    NavigationLink(destination: Text("Canadian Grocery Tax Guide")) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.orange)
                            Text("Canadian Grocery Tax Guide")
                        }
                    }
                    
                    Button(action: {
                        print("Logout pressed")
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.square.fill")
                                .foregroundColor(.red)
                            Text("Log out")
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    SettingsView()
}

