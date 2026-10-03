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


struct File6: View {
   @State var studentArr: [Student] = [Student(name: "Aman"), Student(name: "Aman"), Student(name: "Aman")]
    
    var body: some View {
        List {
            ForEach(studentArr) { student in
                Text(student.name)
            }.onDelete(perform: deleteStudentRecord)
        }
    }
    
    func deleteStudentRecord(offSet: IndexSet) {
        studentArr.remove(atOffsets: offSet)
    }
    
    
}
