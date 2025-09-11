import UIKit
import Foundation
print("Striver Array Video")
// Largest Element in an Array..
let arr = [3,2,1,4,5,-8,70,54,-2,12]
var largest = Int.min

for i in arr {
    if i > largest {
        largest = i
    }
}

print(largest)
