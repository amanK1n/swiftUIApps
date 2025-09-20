
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

// Generics
func swap<T>(_ a: inout T,_ b: inout T) {
    let temp = a
    a = b
    b = temp
}
var a = 10
var b = 20
swap(&a, &b)
print("\(a) \(b)")

// Generic struct
struct Stack<T> {
    var items: [T] = []
    
    mutating func push(_ item: T) {
        items.append(item)
    }
    
    mutating func pop() -> T? {
        items.popLast()
    }
}

var stack = Stack<Int>()
stack.push(10)
stack.push(20)
stack.push(30)
print(stack)
print(stack.pop())

// Generic func

func findInArr<T: Equatable> (_ arr: [T], _ val: T) -> Int? {
    for (index, value) in arr.enumerated() {
        if value == val {
            return index
        }
    }
    return nil
}
let array = [10,20,30]
let array2 = ["John", "Paul", "Saam"]
print(findInArr(array, 20))
print(findInArr(array2, "Saam"))






