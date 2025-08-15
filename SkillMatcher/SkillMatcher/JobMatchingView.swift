//
//  JobMatchingView.swift
//  SkillMatcher
//
//  Created by Chelsea Bonyata on 9/7/24.
//
import SwiftUI

struct JobMatchingView: View {
    var skills: String
    var location: String
    var pages: Int
    @State private var jobs = [Job]()
    @State private var isLoading = true
    @State private var searchProgress: Double = 0.0
    @State private var animateCards = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("Job Matches")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            if !isLoading {
                                Text("\(jobs.count) results found")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Color.clear
                            .frame(width: 28, height: 28)
                    }
                    .padding(.horizontal)
                    
                    // Search info
                    HStack {
                        Label(skills, systemImage: "brain.head.profile")
                            .font(.caption)
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Label(location, systemImage: "location")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
                .padding(.top)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                )
                
                // Content
                if isLoading {
                    LoadingView(progress: searchProgress)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if jobs.isEmpty {
                    EmptyStateView(skills: skills, location: location)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(Array(jobs.enumerated()), id: \.element.id) { index, job in
                                JobCardView(job: job)
                                    .opacity(animateCards ? 1 : 0)
                                    .offset(y: animateCards ? 0 : 20)
                                    .animation(
                                        .spring(response: 0.6, dampingFraction: 0.8)
                                        .delay(Double(index) * 0.1),
                                        value: animateCards
                                    )
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await refreshJobs()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            startLoadingAnimation()
            fetchJobs()
        }
    }
    
    private func startLoadingAnimation() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            searchProgress = 1.0
        }
    }
    
    private func fetchJobs() {
        JobService().fetchJobs(skills: skills, location: location, pages: pages) { fetchedJobs in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    jobs = fetchedJobs
                    isLoading = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    animateCards = true
                }
            }
        }
    }
    
    private func refreshJobs() async {
        animateCards = false
        isLoading = true
        
        await withCheckedContinuation { continuation in
            JobService().fetchJobs(skills: skills, location: location, pages: pages) { fetchedJobs in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        jobs = fetchedJobs
                        isLoading = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        animateCards = true
                    }
                    
                    continuation.resume()
                }
            }
        }
    }
}

struct LoadingView: View {
    let progress: Double
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 8)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(rotationAngle))
                    .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotationAngle)
                
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            VStack(spacing: 8) {
                Text("Searching for opportunities...")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text("Finding the best matches for your skills")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
}

struct EmptyStateView: View {
    let skills: String
    let location: String
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Jobs Found")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("We couldn't find any matches for **\(skills)** in **\(location)**")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 12) {
                Text("Try:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "arrow.right.circle")
                        Text("Different keywords or skills")
                    }
                    HStack {
                        Image(systemName: "arrow.right.circle")
                        Text("Broader location search")
                    }
                    HStack {
                        Image(systemName: "arrow.right.circle")
                        Text("More general job titles")
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

struct JobCardView: View {
    let job: Job
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(job.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    Text(job.employer_name)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                Image(systemName: "building.2")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            // Location
            HStack {
                Image(systemName: "location")
                    .foregroundColor(.green)
                Text(job.job_city)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Apply Button
            if let jobURL = URL(string: job.job_url), UIApplication.shared.canOpenURL(jobURL) {
                Link(destination: jobURL) {
                    HStack {
                        Image(systemName: "arrow.up.right.square")
                        Text("Apply Now")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            } else {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                    Text("Application link unavailable")
                        .font(.caption)
                }
                .foregroundColor(.orange)
                .padding(.vertical, 8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
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

struct JobMatchingView_Previews: PreviewProvider {
    static var previews: some View {
        JobMatchingView(skills: "iOS Developer", location: "Houston, TX", pages: 1)
    }
}
