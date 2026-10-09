//
//  Intellipaat_AmanTests.swift
//  Intellipaat_AmanTests
//
//  Created by comviva on 09/10/26.
//

import Testing
import XCTest
@testable import Intellipaat_Aman

@MainActor
final class CourseDetailViewModelTests: XCTestCase {
    func testMarkingPendingLessonCompletesItAndUpdatesProgress() {
        let course = Course(
            id: 1,
            title: "Python Programming",
            instructor: "John Smith",
            progress: 65,
            lessons: 20
        )
        var reportedProgress: Int?
        let viewModel = CourseDetailViewModel(course: course) { progress in
            reportedProgress = progress
        }

        viewModel.load()

        guard case .success(let before) = viewModel.state else {
            return XCTFail("Lessons did not load")
        }
        XCTAssertEqual(before.lessons.filter(\.isCompleted).count, 13)
        XCTAssertEqual(before.progress, 65)

        viewModel.markCompleted(14)

        guard case .success(let after) = viewModel.state else {
            return XCTFail("Lessons missing after update")
        }
        XCTAssertEqual(after.lessons.first { $0.id == 14 }?.isCompleted, true)
        XCTAssertEqual(after.lessons.filter(\.isCompleted).count, 14)
        XCTAssertEqual(after.progress, 70)
        XCTAssertEqual(reportedProgress, 70)
    }
}
