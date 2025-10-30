//
//  ContentView.swift
//  08-Moonshot
//
//  Created by Sayed on 29/10/25.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [String : Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    var body: some View {
        Text("Tots: \(astronauts.count) astronauts loaded.")
        Text("Tots: \(missions.count) missions loaded.")
    }
}


struct AdaptiveGridExample: View {
    let layout = [GridItem(.adaptive(minimum: 80))]
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: layout) {
                ForEach(0..<1000) {
                    Text("Text \($0)")
                }
            }
        }
    }
}




struct User: Codable {
    let name: String
    let address: Address
}
struct Address: Codable {
    let street: String
    let city: String
}

struct CodableDataExample: View {
    var body: some View {
        Button("Deconde JSUN") {
            let ip = """
            {
                "name": "Yailor Wift",
                "address": {
                    "street": "555, Wailor Qwift Venyu",
                    "city": "Nashville"
                }
            }
            """
            let data = Data(ip.utf8)
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: data) {
                print("Name: ", user.name)
                print("Street: ", user.address.street)
            }
        }
    }
}


#Preview {
    ContentView()
}
