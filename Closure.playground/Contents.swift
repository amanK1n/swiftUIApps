
let team = ["Gloria", "Suzanne", "Piper", "Tiffany", "Tasha"]
//let sortedTeam = team.sorted()
//print(sortedTeam)
let capTeam = team.sorted(by: { (name1: String, name2: String) -> Bool in
    print("name1: ", name1)
    print("name2: ", name2)
    if name1 == "Suzanne" {
        return true
    } else if name2 == "Suzanne" {
        return false
    }
    
    return name1 < name2
    
})
print(capTeam)
