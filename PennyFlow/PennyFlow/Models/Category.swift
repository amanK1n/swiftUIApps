//
//  Category.swift
//  PennyFlow
//
//  Created by comviva on 27/08/26.
//


import Foundation
import SwiftData

@Model
final class Category {
    @Attribute(.unique) var id: UUID
    var name: String
    var icon: String
    var colorHex: String
    var createdAt: Date
    var updatedAt: Date
    var isDeleted: Bool
    var syncStatus: SyncStatus

    init(
        id: UUID = UUID(),
        name: String,
        icon: String,
        colorHex: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isDeleted: Bool = false,
        syncStatus: SyncStatus = .pending
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isDeleted = isDeleted
        self.syncStatus = syncStatus
    }
}
