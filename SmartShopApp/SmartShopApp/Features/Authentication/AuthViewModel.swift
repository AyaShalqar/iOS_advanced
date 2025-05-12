import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: AppUser?
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            let work = DispatchWorkItem {
                self?.isAuthenticated = user != nil
                if let user = user {
                    self?.user = AppUser(id: user.uid, email: user.email ?? "", name: user.displayName ?? "")
                }
            }
            DispatchQueue.main.async(execute: work)
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            let work = DispatchWorkItem {
                if let error = error {
                    self?.error = error.localizedDescription
                }
            }
            DispatchQueue.main.async(execute: work)
        }
    }
    
    func signUp(email: String, password: String, name: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            let work = DispatchWorkItem {
                if let error = error {
                    print("❌ Firebase signUp error:", error.localizedDescription) // ← добавлено
                    self?.error = error.localizedDescription
                    return
                }

                if let user = result?.user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = name
                    changeRequest.commitChanges { error in
                        let innerWork = DispatchWorkItem {
                            if let error = error {
                                print("❌ Firebase profile update error:", error.localizedDescription) // ← добавлено
                                self?.error = error.localizedDescription
                            }
                        }
                        DispatchQueue.main.async(execute: innerWork)
                    }
                }
            }
            DispatchQueue.main.async(execute: work)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            self.error = error.localizedDescription
        }
    }
}
