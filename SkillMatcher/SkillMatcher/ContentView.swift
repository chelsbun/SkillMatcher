//
//  ContentView.swift
//  SkillMatcher
//
//  Created by Chelsea Bonyata on 9/7/24.
//
import SwiftUI

struct ContentView: View {
    @State private var skill = ""
    @State private var location = ""
    @State private var numberOfPages = 1
    @State private var skillsList = [String]()
    @State private var showJobMatching = false
    @State private var isAddingSkill = false
    @State private var buttonScale = 1.0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SkillMatcher")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("Find your perfect job match")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Skills input
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            TextField("Enter a skill (e.g., Swift, iOS)", text: $skill)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit {
                                    addSkill()
                                }
                            
                            Button(action: {
                                addSkill()
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                            .scaleEffect(buttonScale)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: buttonScale)
                        }
                        .padding(.horizontal)
                        
                        // Display added skills
                        if !skillsList.isEmpty {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 8) {
                                ForEach(skillsList, id: \.self) { skill in
                                    SkillPillView(skill: skill) {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            if let index = skillsList.firstIndex(of: skill) {
                                                skillsList.remove(at: index)
                                            }
                                        }
                                    }
                                    .transition(.asymmetric(
                                        insertion: .scale.combined(with: .opacity),
                                        removal: .scale.combined(with: .opacity)
                                    ))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Location input
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Location", systemImage: "location.circle")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter a location (e.g., Houston, TX)", text: $location)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal)
                    
                    // Results configuration
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Results", systemImage: "doc.text")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            Text("Pages: \\(numberOfPages)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Stepper("", value: $numberOfPages, in: 1...5)
                                .labelsHidden()
                        }
                    }
                    .padding(.horizontal)
                    
                    // Search
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            showJobMatching = true
                        }
                        
                    }) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text("Find Job Matches")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .scaleEffect(buttonScale)
                    .disabled(skillsList.isEmpty || location.isEmpty)
                    .opacity(skillsList.isEmpty || location.isEmpty ? 0.6 : 1.0)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    Spacer(minLength: 20)
                }
            }
            .sheet(isPresented: $showJobMatching) {
                JobMatchingView(
                    skills: skillsList.joined(separator: " "),
                    location: location,
                    pages: numberOfPages
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
        }
        .navigationBarHidden(true)
    }
    
    private func addSkill() {
        guard !skill.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            skillsList.append(skill.trimmingCharacters(in: .whitespacesAndNewlines))
            skill = ""
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            buttonScale = 0.9
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                buttonScale = 1.0
            }
        }
        
    }
}

// Custom Skill Pill Component
struct SkillPillView: View {
    let skill: String
    let onDelete: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 4) {
            Text(skill)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Button(action: {
                onDelete()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}