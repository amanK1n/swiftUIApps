//
//  SyncStatus.swift
//  PennyFlow
//
//  Created by comviva on 27/08/26.
//

import Foundation
import Foundation

enum SyncStatus: String, Codable, CaseIterable {
    case pending
    case synced
    case conflict
}
