//
//  TabbarView.swift
//  List
//
//  Created by comviva on 30/08/26.
//
import SwiftUI
struct TabbarView: View {
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Text("Home")
                    Image(systemName: "house")
                }
            
            SearchView()
                .tabItem {
                    Text("Search")
                    Image(systemName: "magnifyingglass")
                }
            
            PlayView()
                .tabItem {
                    Text("Play")
                    Image(systemName: "play")
                }
            NotesView()
                .tabItem {
                    Text("Notes")
                    Image(systemName: "pencil")
                }
        }.accentColor(.purple)
    }
}
