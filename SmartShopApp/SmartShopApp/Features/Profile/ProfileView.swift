import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text(authViewModel.user?.name ?? "")
                            .font(.headline)
                        Text(authViewModel.user?.email ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section {
                Button(role: .destructive) {
                    authViewModel.signOut()
                } label: {
                    HStack {
                        Image(systemName: "arrow.right.square")
                        Text("Sign Out")
                    }
                }
            }
        }
        .navigationTitle("Profile")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
} 