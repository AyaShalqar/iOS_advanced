//
//  InterestView.swift
//  lab1
//
//  Created by Dias Yerlan on 22.02.2025.
//

import SwiftUI

struct Hobby: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
}

struct InterestView: View {
    let hobbies = [
        Hobby(name: "Football", description: "Played professionally in Kazakhstan's 1st league for FC Kyran.", icon: "soccerball"),
        Hobby(name: "Jiu-Jitsu", description: "Training in jiu-jitsu for half a year.", icon: "figure.wrestling"),
        Hobby(name: "Backend Development", description: "Developing projects using Golang.", icon: "server.rack"),
        Hobby(name: "Coding", description: "Building efficient backend systems and APIs.", icon: "terminal"),
        Hobby(name: "Sports", description: "Passionate about various sports and physical activities.", icon: "figure.run"),
        Hobby(name: "Wrestling", description: "Enjoying combat sports and martial arts.", icon: "figure.wrestling"),
        Hobby(name: "Team Sports", description: "Enjoying the camaraderie and strategy of team sports.", icon: "person.3.fill"),
        Hobby(name: "Fitness", description: "Maintaining physical health through regular exercise.", icon: "dumbbell"),
        Hobby(name: "Technology", description: "Exploring new technologies and programming languages.", icon: "desktopcomputer"),
    ]
    
    @State private var tappedHobbyID: UUID? = nil
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.indigo.opacity(0.4), .orange.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            List(hobbies) { hobby in
                HStack(spacing: 16) {
                    Image(systemName: hobby.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                        .scaleEffect(tappedHobbyID == hobby.id ? 1.3 : 1.0)
                        .animation(.interpolatingSpring(stiffness: 200, damping: 5), value: tappedHobbyID)
                        .onTapGesture {
                            tappedHobbyID = hobby.id
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                tappedHobbyID = nil
                            }
                        }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(hobby.name)
                            .font(.headline)
                        Text(hobby.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Interests and hobbies")

        }
        
        
    }
}

#Preview {
    InterestView()
    
}
