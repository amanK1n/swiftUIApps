//
//  CourseDashboardViewModel.swift
//  Intellipaat_Aman
//
//  Created by comviva on 09/10/26.
//


import Foundation


@MainActor
@Observable
final class CourseDashboardViewModel {
    var state: ScreenState<[Course]> = .loading

    private let courseService: CourseServicing

    init(courseService: CourseServicing = CourseService()) {
        self.courseService = courseService
    }

    func load() async {
        state = .loading
        do {
            let courses = try await courseService.fetchCourses()
            state = courses.isEmpty ? .empty : .success(courses)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            state = .failure(message)
        }
    }
    func updateProgress(courseID: Int, progress: Int) {
        guard case .success(var courses) = state,
              let index = courses.firstIndex(where: { $0.id == courseID })
        else { return }

        courses[index].progress = progress
        state = .success(courses)
    }
}
