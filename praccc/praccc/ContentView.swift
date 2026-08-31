//
//  ContentView.swift
//  praccc
//
//  Created by comviva on 31/08/26.
//

import SwiftUI

struct FavList: Identifiable {
    let id: UUID = UUID()
    var name: String? = ""
    init(name: String? = "") {
      
        self.name = name
    }
}

struct CompleteFavList: Identifiable {
    let id: UUID = UUID()
    var name: String?
    var favItem: [FavList]?
    init(name: String? = "", favItem: [FavList]? = [FavList(name: "abc")]) {
        self.name = name
        self.favItem = favItem
    }
}

struct ContentView: View {
    //    var fav: [String] = ["GTA", "BMW", "Macbook Pro", "Assassin's Creed", "Audi", "Alienware"]
    //    var favCat: [String] = ["Games", "Lappy", "Cars"]
    //    @State var favList: [FavList] = [FavList(name: "GTA"),
    //                                     FavList(name: "BMW"),
    //                                     FavList(name: "Macbook Pro"),
    //                                     FavList(name: "Assassin's Creed"),
    //                                     FavList(name: "Audi"),
    //                                     FavList(name: "Alienware")]
    //
    
    @State var completeFavList: [CompleteFavList] = [CompleteFavList(name: "Games",
                                                                     favItem: [FavList(name: "GTA"),
                                                                               FavList(name: "Assassin's Creed")]),
                                                     CompleteFavList(name: "Lappy",
                                                                     favItem: [FavList(name: "Macbook Pro"),
                                                                               FavList(name: "Alienware")]),
                                                     CompleteFavList(name: "Cars",
                                                                     favItem: [FavList(name: "Audi"),
                                                                               FavList(name: "BMW")])]
    
    
    var body: some View {
        
        TabBarView(completeFavList: completeFavList)
    }
}

struct FavItemsView: View {
    var completeFavList: [CompleteFavList]
    var body: some View {
        NavigationView {
            
            List {
                ForEach(completeFavList, id: \.id) { favCat in
                    Section(header: Text(favCat.name ?? "")) {
                        
                            ForEach(favCat.favItem ?? [], id: \.id) { fav in
                                NavigationLink(destination: DetailedView(completeFavList: favCat, favItem: fav) ) {
                                    Text(fav.name ?? "")
                                }
                            }
                        
                    }
                }
            }
           
        }
    }
}

struct DetailedView: View {
    var completeFavList: CompleteFavList
    var favItem: FavList
    var body: some View {
        VStack {
            List {
                
                    Text(favItem.name ?? "")
                
            }
        }.navigationBarTitle(completeFavList.name ?? "")
        
        
    }
}

#Preview {
    ContentView()
}
