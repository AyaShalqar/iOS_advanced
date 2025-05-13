import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""

    var body: some View {
        VStack {
            Spacer()

            Text("SHOP SMART")
                .font(.caption)
                .foregroundColor(.orange)
                .bold()
                .padding(.bottom, 4)

            Text("Your Personal\nShopping Assistant")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text("Smart shopping is the future of shopping.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.bottom, 32)

            VStack(spacing: 16) {
                if isSignUp {
                    TextField("Name", text: $name)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3)))
                        .autocapitalization(.words)
                }

                HStack {
                    Image(systemName: "envelope")
                    TextField("Enter your email address...", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3)))

                HStack {
                    Image(systemName: "lock")
                    SecureField("Enter your password...", text: $password)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3)))
            }
            .padding(.horizontal)

            Button(action: {
                if isSignUp {
                    authViewModel.signUp(email: email, password: password, name: name)
                } else {
                    authViewModel.signIn(email: email, password: password)
                }
            }) {
                Text(isSignUp ? "Sign Up" : "Sign In")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(12)
                    .padding(.top, 20)
            }
            .padding(.horizontal)

            Button(action: {
                withAnimation {
                    isSignUp.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "arrow.right")
                    Text(isSignUp ? "I already have an account" : "Create new account")
                }
                .foregroundColor(.orange)
                .font(.subheadline)
                .padding(.top, 12)
            }

            if let error = authViewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.top, 12)
            }

            Spacer()
        }
        .padding()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView().environmentObject(AuthViewModel())
    }
}
