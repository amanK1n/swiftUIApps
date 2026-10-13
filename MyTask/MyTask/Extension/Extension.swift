//
//  Extension.swift
//  MyTask
//
//  Created by comviva on 11/10/26.
//

import Foundation
extension Date {
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        dateFormatter.dateFormat = "mm/dd/yyyy"
        
        let result = dateFormatter.string(from: self)
        
        return result
    }
}
