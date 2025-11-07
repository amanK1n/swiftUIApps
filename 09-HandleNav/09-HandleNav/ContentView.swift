//
//  ContentView.swift
//  09-HandleNav
//
//  Created by Sayed on 05/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("aaa")
    }
}



class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }
    
    
    
    
    private let savedPath = URL.documentsDirectory.appendingPathComponent("SavedPath")
    init() {
        if let data = try? Data(contentsOf: savedPath) {
            if let decodePath = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decodePath)
                return
            }
        }
        path = NavigationPath()
    }
    
    
    
    
    
    func save() {
        guard let repn = path.codable else { return }
        do {
             let data = try? JSONEncoder().encode(repn)
            try data?.write(to: savedPath)
        } catch {
            print("Failed to decode!!")
        }
    }
    
}


struct Example5: View {
    @State private var pathStore = PathStore()//NavigationPath() //[Int]()
    var body: some View {
        NavigationStack(path: $pathStore.path) {
            DetailViewExp5(number: 0, path: $pathStore.path)
                .navigationDestination(for: Int.self) { i in
                    DetailViewExp5(number: i,path: $pathStore.path)
                }
        }
    }
}


struct DetailViewExp5: View {
    var number: Int
    @Binding var path: NavigationPath//[Int]
    var body: some View {
        NavigationLink("Go to random page number", value: Int.random(in: 1...1000))
            .navigationTitle("Rando number \(number)")
            .toolbar {
                Button("Home") {
                    path = NavigationPath()// path.removeAll()
                }
            }
    }
}



struct Example4: View {
    @State private var path = NavigationPath() // Type Eraser tsakes multiple values of hashable data
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(0..<5) { i in
                    NavigationLink("Select num \(i)", value: i+100) // Takes value single type only INT
                }
                ForEach(0..<5) { i in
                    NavigationLink("Select str \(i)", value: String(i)) // Takes value single type only STR
                }
            }.navigationDestination(for: Int.self) { selection in
                Text("You selected Num \(selection)")
            }
            .navigationDestination(for: String.self) { selection in
                Text("You selected Stringf \(selection)")
            }.toolbar {
                Button("Sayed") {
                    path.append(123) // Takes up INT
                }
                Button("Aman") {
                    path.append("Nikky") //ALSO  Takes up STRING
                }
            }
        }
    }
}


struct Example3: View {
    @State private var path = [Int]()
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button("Show 32") {
                   path = [32]
                }
                Button("Show 64") {
                    path.append(64)
                }
                Button("Show 32 & 64") {
                    path = [32, 64]
                }
            }.navigationDestination(for: Int.self) { selection in
                Text("You selected \(selection)")
            }
        }
    }
    
}


struct Example2: View {
    var body: some View {
        NavigationStack {
            List(0..<100) { i in
                NavigationLink("Select \(i)", value: i)
            }
            .navigationDestination(for: Int.self) { selection in
                Text("You selected \(selection)")
            }
            .navigationDestination(for: StudentExp2.self) { student in
                Text("Student no. \(student.id) is selected")
            }
        }
    }
}

struct StudentExp2: Hashable {
    var id = UUID()
    var name: String
    var age: Int
}


struct Example1: View {
    var body: some View {
        NavigationStack {
            List(0..<200) { num in
            NavigationLink("Tap muei") {
                    DetailsViewExp1(num: num)
                }
            }
        }
    }
}

struct DetailsViewExp1: View {
    var num: Int
    var body: some View {
        Text("Details \(num)")
    }
    init(num: Int) {
        self.num = num
        print("Creating DetailsView \(num)")
    }
}




#Preview {
    ContentView()
}
