//
//  LandmarkDetailView.swift
//  List
//
//  Created by comviva on 30/08/26.
//

import Foundation
import SwiftUI

struct LandmarkDetailView: View {
    var landmark: Landmark
    var body: some View {
        VStack {
            Image(landmark.photo)
                .resizable()
                .scaledToFit()
            Text(landmark.description)
            Spacer()
        }.padding()
        .navigationBarTitle(landmark.name, displayMode: .large)
    }
}
