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

print("Sol1: Largest::", largest)
// Second Largest Element in an Array..
let arr2 = [3,2,1,4,5,-8,70,54,-2,12]
var secondLargest = Int.min
var largest2 = Int.min

for i in arr2 {
    if i > largest2 {
        largest2 = i
    }
}

for i in arr2 {
    if i != largest2 && i > secondLargest {
        secondLargest = i
    }
}

print("Sol2(a): Second Largest::Better", secondLargest)

// Second Largest Element in an Array..Optimal
let arr3 = [3,2,1,4,5,-8,70,54,-2,12]
var secondLargest3 = Int.min
var largest3 = arr3[0]

for i in arr3 {
    
    if i > largest3 {
        secondLargest3 = largest3
        largest3 = i
    } else if i < largest3 && i > secondLargest3 {
        secondLargest3 = i
    }
    
}
print("Sol2(b): Second Largest::Optimal", secondLargest)

// Second Smallest Element in an Array..Optimal
let arr4 = [3,2,1,4,5,-8,70,54,-2,12]
var smallest4 = Int.max
var secondSmallest4 = Int.max
for i in arr4 {
    if i < smallest4 {
        secondSmallest4 = smallest4
        smallest4 = i
    } else if i > smallest4 && i < secondSmallest4 {
        secondSmallest4 = i
    }
}
print("Sol3(a): Smallest::Optimal", smallest4)
print("Sol3(b): Second Smallest::Optimal", secondSmallest4)
print("new")
