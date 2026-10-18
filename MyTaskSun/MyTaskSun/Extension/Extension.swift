//
//  Extension.swift
//  MyTaskSun
//
//  Created by comviva on 18/10/26.
//

import Foundation

extension Date {
    
    func toDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.dateFormat = "dd/MM/yy"
        
        let result = formatter.string(from: self)
        
        return result
    }
}
