//
//  ContentView.swift
//  List
//
//  Created by comviva on 30/08/26.
//

import SwiftUI

struct ContentView: View {
    let cities = BundleDecoder.getCityData()
    var body: some View {
        NavigationView {
            List {
                ForEach(cities, id: \.cityId) { city in
                    Section(header: Text(city.name)) {
                        ForEach(city.landmarks, id: \.landmarkId) { landmark in
                            
                            NavigationLink(destination: LandmarkDetailView(landmark: landmark)) {
                                LandmarkRow(landmark: landmark)
                            }
                           
                        }
                    }
                    
                }
            }.navigationBarTitle("Landmark")
        }
    }
}

#Preview {
    ContentView()
}
