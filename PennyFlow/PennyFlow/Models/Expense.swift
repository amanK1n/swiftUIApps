//
//  Expense.swift
//  PennyFlow
//
//  Created by comviva on 27/08/26.
//


import Foundation
import SwiftData

@Model
final class Expense {
    @Attribute(.unique) var id: UUID
    var amount: Decimal
    var title: String
    var note: String?
    var date: Date
    var categoryId: UUID
    var createdAt: Date
    var updatedAt: Date
    var isDeleted: Bool
    var syncStatus: SyncStatus

    init(
        id: UUID = UUID(),
        amount: Decimal,
        title: String,
        note: String? = nil,
        date: Date = Date(),
        categoryId: UUID,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isDeleted: Bool = false,
        syncStatus: SyncStatus = .pending
    ) {
        self.id = id
        self.amount = amount
        self.title = title
        self.note = note
        self.date = date
        self.categoryId = categoryId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isDeleted = isDeleted
        self.syncStatus = syncStatus
    }
}
