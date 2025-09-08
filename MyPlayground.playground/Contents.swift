import UIKit

var greeting = "Hello, playground"
var name = "Ted"
name = "Rebbeca"
name = "Kee;ey"

let character = "Daphne"

var playerName = "Megan"
print(playerName)
playerName = "Alex"
print(playerName)
playerName = "Jordan"
print(playerName)
playerName = "Taylor"
print(playerName)
print(playerName)

// STRING
let quote = "Then he tapped a sign saying \"Believe\" and walked away."
let movie = """
A day in
the life of an
Apple engineer
"""
let nameLength = quote.count
print(nameLength)
print(movie.uppercased())
print(movie.hasPrefix("A day"))
// INT
let reallyBig = 100_000_000
let number = 120
print(number.isMultiple(of: 3))
// Double
let num = 0.1 + 0.2
print(num)
print(round(num))
// Bool
let filename = "paris.jpg"
print(filename.hasSuffix(".jpg"))
let number1 = 120
print(number1.isMultiple(of: 3))
var isAuthenticated = false
isAuthenticated = !isAuthenticated
print(isAuthenticated)
isAuthenticated = !isAuthenticated
print(isAuthenticated)
var gameOver = false
print(gameOver)

gameOver.toggle()
print(gameOver)

print("5 x 5 is \(5 * 5)")
var numsss = "3223"
numsss = numsss.replacingOccurrences(of: "3", with: "")
print("sss::", numsss)
var numx = Array(numsss)
print(numx)
print(numx.count)
var nnn = numx.compactMap { Int(String($0)) }
print(nnn)

/////
print("#########$$$$$$$$$NEW LINE######")
var nums = [7,25,21,2,20,7,24,9,24,24,6,22,5,1,26,17,18,29,25,9,8,27,6,26,8,5,27,5,0,29,26,29,24,18,23,14,25,17,15,20,11,22,4,17,15,0,26,3,21,21,12,0,10,10,26,19,15,23,16,7,14,12,7,8,0,0,14,26,18,22,8,21,6,12,0,21,4,26,16,26,18,21]

for i in nums.enumerated() {
    if let index = nums.firstIndex(of: 26) {
        nums.remove(at: index)
    }
}
print(nums)

let n = 10
var arr: [Int] = []
arr.append(1)
arr.append(n - 1)
print(arr)

var truth: [Character: Character] = ["}":"{", "]":"[", ")":"("]

var stack: [Character] = []
var str = "{{)"

for ch in str {
    if truth.values.contains(ch) {
    print("Added: ", ch)
        stack.append(ch)
    } else {
  
    if let last = stack.last {
    print("Last:: ", last)
    print("Char:", ch)
    print("Char:Val", truth[ch] ?? "")
       if last == truth[ch] {
           let x = stack.removeLast()
           print("rem: ", x)
       } else {
           print("NO match")
       }
    }
    }
}

print(stack)

       
