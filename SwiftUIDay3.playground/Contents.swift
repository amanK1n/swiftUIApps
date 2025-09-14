let employee: [String : String] = ["name" : "Taylor Swift",
                                   "job" : "Singer-Songwriter",
                                   "location" : "Nashville"]

print(employee["name", default: "Unknown"])
print(employee["age"] ?? "NOT KNOWN")

let hasGraduated: [String : Bool] = ["Eric" : true,
                                       "John" : false,
                                       "Nikky": true]
print(hasGraduated["Nikky", default: false])

let olympics: [Int : String] = [2012 : "London",
                                2016 : "Rio",
                                2020 : "Tokyo"]

print(olympics[2016] ?? "Unknown")

var heights: [String : Int] = [String : Int]()
heights["Alice"] = 160
heights["Peter"] = 200

print(heights["Alice"] ?? 0)
