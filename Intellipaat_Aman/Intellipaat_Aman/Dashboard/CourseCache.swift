//
//  CourseCache.swift
//  Intellipaat_Aman
//
//  Created by Aman on 09/10/26.
//


import Foundation

struct CourseCache {
    private let fileURL: URL = {
        let folder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return folder.appendingPathComponent("courses-cache.json")
    }()

    func save(_ courses: [Course]) {
        guard let data = try? JSONEncoder().encode(courses) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    func load() -> [Course]? {
        guard let data = try? Data(contentsOf: fileURL),
              let courses = try? JSONDecoder().decode([Course].self, from: data)
        else { return nil }
        return courses
    }
}
