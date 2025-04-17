//
//  GoalsView.swift
//  lab1
//
//  Created by Dias Yerlan on 22.02.2025.
//

import SwiftUI

struct GoalsView: View {
    let goals = [
        "Advance my skills in Golang and backend development.",
        "Contribute to open-source projects in the backend space.",
        "Achieve a higher belt in Jiu-Jitsu.",
        "Build high-performance, scalable backend systems.",
        "Continue my football career and improve my skills.",
        "Learn new programming languages and frameworks.",
        "Develop a successful personal project using Golang."
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.4), .purple.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(goals, id: \.self) { goal in
                        HStack(alignment: .center, spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)

                            Text(goal)
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 4)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Goals")

    }
}

#Preview {
    GoalsView()
}
