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

// Find the num that appears once, and others twice
let arr2 = [1,1,2,3,3,4,4]
var countDict: [Int : Int] = [Int : Int]()
for i in arr2 {
    countDict[i , default: 0] += 1
}

for (key, value) in countDict {
    if value == 1 {
        print("Sol3: The number that appears once is:", key)
    }
}

for i in countDict {
    if i.value == 1 {
        //print(i.key)
    }
}

// Find longest sub-array - ONLY POSITIVE
let arr3 = [1,2,3,1,1,1,1,3,3]
let k = 6
var maxLength: Int = 0
var right = 0
var left = 0
var sum = arr3[0]
var n = arr3.count
while right < n {
    
    right += 1
    if right < n {
        sum += arr3[right]
    }
    
    while (left <= right && sum > k) {
        sum -= arr3[left]
        left += 1
    }
    
    if (sum == k) {
        maxLength = max(maxLength, right - left + 1)
    }
    
    
}
print("Sol4: Max len is:", maxLength)

// Two sum Problem
let arr4 = [2,6,5,8,11]
let target = 14
var indexDict: [Int : Int] = [Int : Int]()

for (index, value) in arr4.enumerated() {
    
    if let j = indexDict[target - value] {
        print("\(index) and \(j)")
    }
    
    
    if indexDict[value] == nil {
        indexDict[value] = index
    }
}
