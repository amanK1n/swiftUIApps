//
//  File6.swift
//  pracAppSun
//
//  Created by comviva on 03/10/26.
//

import Foundation
import SwiftUI

struct Student: Identifiable {
    let id: UUID = UUID()
    let name: String
}


struct File6_0: View {
   @State var studentArr: [Student] = [Student(name: "Aman"), Student(name: "Aman"), Student(name: "Aman")]
    
    var body: some View {
        List {
            ForEach(studentArr) { student in
                Text(student.name)
            }.onDelete(perform: deleteStudentRecord)
        }
    }
    
    func deleteStudentRecord(offset: IndexSet) {
        studentArr.remove(atOffsets: offset)
    }
    
    
}

struct File6: View {
    let city = BundleDecoder.decodeLandmarkJSON()
    var body: some View {
        
        NavigationView {
           
            List {
                ForEach(city, id: \.cityId) { city in
                    Section(header: Text(city.name)) {
                        
                        ForEach(city.landmarks, id: \.landmarkId) { landmark in
                            NavigationLink(destination: LandmarkDetailView(landmark: landmark)) {
                                LandmarkRowView(landmark: landmark)
                            }
                            
                            
                            
                        }
                        
                    }
                }
            }
        
        
        }.navigationBarTitle("Landmarks", displayMode: .large)
        
        
        
        
    }
}

struct LandmarkRowView: View {
    var landmark: Landmark
    var body: some View {
        HStack {
            Image(landmark.photo)
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
                .cornerRadius(12.5)
            Text(landmark.name)
            Spacer()
        }
        
    }
}


struct LandmarkDetailView: View {
    var landmark: Landmark
    
    var body: some View {
        VStack {
            Image(landmark.photo)
                .resizable()
                .scaledToFit()
            Text(landmark.name)
                .font(.largeTitle)
            Text(landmark.description)
                .font(.caption)
            Spacer()
        }.navigationTitle("Landmark Details")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        
    }
}
