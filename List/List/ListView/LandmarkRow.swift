//
//  LandmarkRow.swift
//  List
//
//  Created by comviva on 30/08/26.
//

import Foundation
import SwiftUI
struct LandmarkRow: View {
    var landmark: Landmark
    var body: some View {
        HStack {
            Image(landmark.photo)
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
            Text(landmark.name)
        }
    }
}
