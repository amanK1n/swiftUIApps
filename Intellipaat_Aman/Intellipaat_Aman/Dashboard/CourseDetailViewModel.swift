//
//  CourseDetailViewModel.swift
//  Intellipaat_Aman
//
//  Created by comviva on 09/10/26.
//


import Foundation

@MainActor
@Observable
final class CourseDetailViewModel {
    var state: ScreenState<CourseDetail> = .loading

    private let course: Course
    private let onProgressChange: (Int) -> Void

    init(course: Course, onProgressChange: @escaping (Int) -> Void = { _ in }) {
        self.course = course
        self.onProgressChange = onProgressChange
    }

    func load() {
        state = .loading
        guard course.lessons > 0 else {
            state = .empty
            return
        }
        state = .success(LessonCatalog.makeDetail(for: course))
    }

    func markCompleted(_ lessonID: Int) {
        guard case .success(var detail) = state,
              let index = detail.lessons.firstIndex(where: { $0.id == lessonID }),
              !detail.lessons[index].isCompleted
        else { return }

        detail.lessons[index].isCompleted = true
        state = .success(detail)
        onProgressChange(detail.progress)
    }
}