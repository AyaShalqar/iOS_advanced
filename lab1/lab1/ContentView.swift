//
//  ContentView.swift
//  lab1
//
//  Created by Dias Yerlan on 21.02.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                ProfileView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            NavigationView {
                InterestView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "soccerball")
                Text("Interests")
            }
            NavigationView {
                GoalsView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "target")
                Text("Goals")
            }
        }
        .tint(.black)
    }
}

#Preview {
    ContentView()
}
