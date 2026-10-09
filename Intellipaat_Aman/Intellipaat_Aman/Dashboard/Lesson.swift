//
//  Lesson.swift
//  Intellipaat_Aman
//
//  Created by Aman on 09/10/26.
//


import Foundation

struct Lesson: Identifiable {
    let id: Int
    let title: String
    var isCompleted: Bool
}

struct CourseDetail {
    let title: String
    var lessons: [Lesson]

    var progress: Int {
        guard !lessons.isEmpty else { return 0 }
        let completed = lessons.filter(\.isCompleted).count
        return Int((Double(completed) / Double(lessons.count) * 100).rounded())
    }
}

enum LessonCatalog {
    static func makeDetail(for course: Course) -> CourseDetail {
        let names = titles(for: course.id, count: course.lessons)
        let completedCount = Int((Double(course.progress) / 100 * Double(names.count)).rounded())

        let lessons = names.enumerated().map { index, title in
            Lesson(id: index + 1, title: title, isCompleted: index < completedCount)
        }
        return CourseDetail(title: course.title, lessons: lessons)
    }

    private static func titles(for courseID: Int, count: Int) -> [String] {
        let named: [String]
        switch courseID {
        case 1:
            named = [
                "Introduction", "Variables & Data Types", "Functions", "OOP",
                "Control Flow"
            ]
        case 2:
            named = [
                "Introduction", "Prompts", "Tokens", "Models",
                "Embeddings"
            ]
        case 3:
            named = [
                "Introduction", "HTML", "CSS", "JavaScript",
                "DOM"
            ]
        default:
            named = []
        }

        if named.count >= count {
            return Array(named.prefix(count))
        }
        let extras = (named.count + 1...count).map { "Lesson \($0)" }
        return named + extras
    }
}
