import UIKit
import Foundation
print("Striver Array Video - Part 1")
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
// Check if the array is sorted
let arr5 = [1,2,1,3,4]
var item = arr5[0]
var isSorted = false
for i in arr5 {
    if i <= item {
        isSorted = false
        break
    } else {
        isSorted = true
    }
}
print("Sol4: isSorted::", isSorted)

// Remove duplicates from Sorted array

var arr6 = [1,1,2,2,2,3,4,4,5]
var resArr6: [Int] = []
var i = 0
resArr6.append(arr6[0])
for j in 1..<arr6.count {
    if arr6[j] != arr6[i] {
        arr6[i + 1] = arr6[j]
        i += 1
      //  resArr6.append(arr6[j])
      //  i = j
    }
}
print("Sol5: Unique Sorted Array::", arr6)//resArr6

// Left Rotate Array by 1 place
var arr7 = [1,2,3,4,5]
let firstElement = arr7[0]
for i in 0..<arr7.count - 1 {
    arr7[i] = arr7[i + 1]
}
arr7[arr7.count - 1] = firstElement
print("Sol6: Left rotate Array by 1 place::", arr7)

// Left Rotate Array by k places
var arr8: [Int] = [1,2,3,4,5]
let k = 6
let d = k % arr8.count
var temp: [Int] = []
for i in 0..<d {
    temp.append(arr8[i])
}

for i in d..<arr8.count {
    arr8[i - d] = arr8[i]
}
var resArr8 = arr8.dropLast(d)
resArr8.append(contentsOf: temp)
print("Sol7: Left rotate Array by K places::mySol:", resArr8)

// Reverse an array
var arr9: [Int] = [1,2,3,4,5]
var reversedArray: [Int] = []
for i in stride(from: arr9.count, to: 0, by: -1) {
    reversedArray.append(arr9[i - 1])
}
print("REV::", reversedArray)
