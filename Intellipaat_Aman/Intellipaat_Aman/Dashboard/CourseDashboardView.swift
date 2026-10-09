//
//  CourseDashboardView.swift
//  Intellipaat_Aman
//
//  Created by Aman on 09/10/26.
//

import SwiftUI

struct CourseDashboardView: View {
    @State private var viewModel = CourseDashboardViewModel()

    var body: some View {
        ScreenStateView(
            state: viewModel.state,
            emptyTitle: "No courses",
            failureTitle: "Couldn't load courses",
            retry: { Task { await viewModel.load() } }
        ) { courses in
            List(courses) { course in
                NavigationLink {
                    CourseDetailView(course: course) { progress in
                        viewModel.updateProgress(courseID: course.id, progress: progress)
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(course.title)
                            .font(.headline)
                        Text(course.instructor)
                            .foregroundStyle(.secondary)
                        Text("Progress: \(course.progress)%")
                        ProgressView(value: Double(course.progress), total: 100)
                        Text("\(course.lessons) lessons")
                            .font(.subheadline)
                        Text("Continue")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(.tint, in: RoundedRectangle(cornerRadius: 8))
                            .foregroundStyle(.white)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle("Course Dashboard")
        .navigationBarBackButtonHidden(true)
        .task { await viewModel.load() }
    }
}
