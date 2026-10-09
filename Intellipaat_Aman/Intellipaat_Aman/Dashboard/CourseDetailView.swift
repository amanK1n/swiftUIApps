//
//  CourseDetailView.swift
//  Intellipaat_Aman
//
//  Created by Aman on 09/10/26.
//


import SwiftUI

struct CourseDetailView: View {
    @State private var viewModel: CourseDetailViewModel

    init(course: Course, onProgressChange: @escaping (Int) -> Void = { _ in }) {
        _viewModel = State(initialValue: CourseDetailViewModel(
            course: course,
            onProgressChange: onProgressChange
        ))
    }

    var body: some View {
        ScreenStateView(
            state: viewModel.state,
            emptyTitle: "No lessons",
            failureTitle: "Couldn't load lessons",
            retry: { viewModel.load() }
        ) { detail in
            List {
                Section {
                    Text(detail.title)
                        .font(.title2.bold())
                    Text("Progress: \(detail.progress)%")
                    ProgressView(value: Double(detail.progress), total: 100)
                }

                Section("Lessons") {
                    ForEach(detail.lessons) { lesson in
                        Button {
                            viewModel.markCompleted(lesson.id)
                        } label: {
                            HStack {
                                Text(lesson.title)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if lesson.isCompleted {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                    Text("Completed")
                                        .foregroundStyle(.secondary)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundStyle(.secondary)
                                    Text("Pending")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .disabled(lesson.isCompleted)
                    }
                }
            }
        }
        .navigationTitle("Course Details")
        .navigationBarTitleDisplayMode(.inline)
        .task { viewModel.load() }
    }
}
