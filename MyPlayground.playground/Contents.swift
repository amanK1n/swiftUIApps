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
