//
//  JobService.swift
//  SkillMatcher
//
//  Created by Chelsea Bonyata on 9/7/24.
//

import Foundation

class JobService {
    func fetchJobs(skills: String, location: String, pages: Int, completion: @escaping ([Job]) -> Void) {
        let encodedSkills = skills.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? skills
        let encodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? location
        
        let headers = [
            "x-rapidapi-key": Config.rapidApiKey,
            "x-rapidapi-host": Config.rapidApiHost
        ]
        
        let request = NSMutableURLRequest(
            url: NSURL(string: "https://jsearch.p.rapidapi.com/search?query=\(encodedSkills)%20in%20\(encodedLocation)&page=1&num_pages=\(pages)&date_posted=all")! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print("Error fetching jobs: \(error)")
                completion([])
            } else if let data = data {
                do {
                    let jobsResponse = try JSONDecoder().decode(JSearchResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(jobsResponse.data)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion([])
                }
            } else {
                print("Unknown error or no data received.")
                completion([])
            }
        })
        
        dataTask.resume()
    }
}

struct JSearchResponse: Codable {
    let data: [Job]
}

struct Job: Identifiable, Codable {
    let id: String
    let title: String
    let employer_name: String
    let job_city: String
    let job_url: String

    enum CodingKeys: String, CodingKey {
        case id = "job_id"
        case title = "job_title"
        case employer_name
        case job_city = "job_city"
        case job_url = "job_apply_link"
    }
}
