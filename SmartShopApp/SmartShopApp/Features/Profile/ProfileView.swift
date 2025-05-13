import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                HStack(spacing: 16) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                        .background(Color(.systemGray5))
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text(authViewModel.user?.name ?? "Name")
                            .font(.headline)
                        Text(authViewModel.user?.email ?? "Email")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)

                
                List {
                    Section(header: Text("GENERAL")) {
                        NavigationLink(destination: Text("Edit Profile View")) {
                            Text("Edit Profile")
                        }
                        NavigationLink(destination: Text("Notifications Settings")) {
                            Text("Notifications")
                        }
                    }

                    Section(header: Text("LEGAL")) {
                        NavigationLink(destination: Text("Terms of Use Screen")) {
                            Text("Terms of Use")
                        }
                        NavigationLink(destination: Text("Privacy Policy Screen")) {
                            Text("Privacy Policy")
                        }
                    }

                    Section {
                        Button(role: .destructive) {
                            authViewModel.signOut()
                        } label: {
                            Text("Logout")
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
