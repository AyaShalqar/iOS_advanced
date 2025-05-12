import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.isAuthenticated {
            MainTabView()
                .environmentObject(authViewModel)
        } else {
            AuthView()
                .environmentObject(authViewModel)
        }
    }
}

struct MainTabView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        
        // Shopping List Tab
        let shoppingListVC = UIHostingController(rootView: ShoppingListView())
        shoppingListVC.tabBarItem = UITabBarItem(title: "Shopping List", image: UIImage(systemName: "cart"), tag: 0)
        
        // Categories Tab
        let categoriesVC = UIHostingController(rootView: CategoriesView())
        categoriesVC.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "folder"), tag: 1)
        
        // History Tab
        let historyVC = UIHostingController(rootView: HistoryView())
        historyVC.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "clock"), tag: 2)
        
        // Profile Tab
        let profileVC = UIHostingController(rootView: ProfileView())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
        
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: shoppingListVC),
            UINavigationController(rootViewController: categoriesVC),
            UINavigationController(rootViewController: historyVC),
            UINavigationController(rootViewController: profileVC)
        ]
        
        return tabBarController
    }
    
    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 