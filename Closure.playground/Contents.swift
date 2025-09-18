
let team = ["Gloria", "Suzanne", "Piper", "Tiffany", "Tasha"]
//let sortedTeam = team.sorted()
//print(sortedTeam)
let capTeam = team.sorted(by: { (name1: String, name2: String) -> Bool in
    if name1 == "Suzanne" {
        return true
    } else if name2 == "Suzanne" {
        return false
    }
    
    return name1 < name2
    
})
print(capTeam)

func doSomething(action: (String) -> Void) {
    print("Hii")
    action("Aman")
    print("Welcome !!")
}

//doSomething { (name: String) -> () in
//    print("Mr. \(name) !!")
//}

var actClosue: (String) -> Void = { (name: String) -> Void in
    print("Chumba Wamba goble di \(name)")
    
}

doSomething(action: actClosue)


func calcSum(sum: (Int, Int) -> Int) {
    print("Let's calc sum")
   let x = sum(10, 20)
    print("The SUM is::", x)
}

calcSum { a, b in
    return a + b
}

let sumClose = { (a: Int, b: Int) -> Int in
    return a + b
}
calcSum(sum: sumClose)





