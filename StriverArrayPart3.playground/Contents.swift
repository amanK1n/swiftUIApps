import UIKit
import Foundation
print("Striver Array Video - Part 3")
print("============================\n")

// find missing number
let arr = [1,2,4,5]
for i in 0..<arr.count {
    if arr[i] != i + 1 {
        print("Sol1: The missing number is:", i + 1)
        break
    }
}

// Max consecutive ones
let arr1 = [1,1,0,1,1,1,0,1,1,1,1,1,1,1,0]
var oneSumArray: [Int] = [Int]()
var count = 0
var largestCount: Int = Int.min
for i in arr1 {
    if i == 1 {
        count += 1
    } else {
        oneSumArray.append(count)
        count = 0
    }
}
oneSumArray.append(count)
for i in oneSumArray {
    if i > largestCount {
        largestCount = i
    }
}
print("Sol2: The max consecutive ones is::", largestCount)


