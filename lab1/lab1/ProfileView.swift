//
//  ProfileView.swift
//  lab1
//
//  Created by Dias Yerlan on 22.02.2025.
//

import SwiftUI

struct ProfileView: View {
    
    let imageURL = URL(string: "https://sun9-3.userapi.com/impf/zSTsaC_fxpSjVaEeTODFWM3so1U5ryRZignBqg/jrtWbf7pXj0.jpg?size=478x604&quality=96&sign=f5a12f8a2e158b1b2f14337341064c0e&type=album")
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.teal.opacity(0.4), .orange.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack(spacing: 16) {
                Spacer()
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    default:
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.red)
                    }
                }
                .frame(width: 200)
                .clipShape(Circle())
                
                Text("Zeinaddin Zurgambayev")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Almaty, Kazakhstan")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("A passionate backend developer who specializes in Golang and loves sports.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Profile")
            .padding()
        }
    }
}

#Preview {
    ProfileView()
}
