//
//  CourseService.swift
//  Intellipaat_Aman
//
//  Created by Aman on 09/10/26.
//

import Foundation

struct Course: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let instructor: String
    var progress: Int
    let lessons: Int
}


protocol CourseServicing {
    func fetchCourses() async throws -> [Course]
}

struct CourseService: CourseServicing {
    private let client = APIClient()
    private let cache = CourseCache()

    func fetchCourses() async throws -> [Course] {
        do {
            let courses: [Course] = try await client.request(
                urlString: "https://raw.githubusercontent.com/amanK1n/config/main/courses.json",
                method: .get
            )
            cache.save(courses)
            return courses
        } catch {
            if let courses = cache.load() {
                return courses
            }
            throw error
        }
    }
}
