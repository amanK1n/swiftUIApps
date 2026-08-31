//
//  TabbarView.swift
//  List
//
//  Created by comviva on 30/08/26.
//
import SwiftUI
struct TabbarView: View {
    @State private var defaultViewTag: Int = 2
    var body: some View {
        TabView(selection: $defaultViewTag) {
            HomeView()
                .tabItem {
                    Text("Home")
                    Image(systemName: "house")
                }.tag(0)
            
            SearchView()
                .tabItem {
                    Text("Search")
                    Image(systemName: "magnifyingglass")
                }.tag(1)
            
            PlayView()
                .tabItem {
                    Text("Play")
                    Image(systemName: "play")
                }.tag(2)
            NotesView()
                .tabItem {
                    Text("Notes")
                    Image(systemName: "pencil")
                }.tag(3)
            Message()
                .tabItem {
                    Text("Message")
                    Image(systemName: "message")
                }.tag(4)
            Message()
                .tabItem {
                    Text("Message2")
                    Image(systemName: "message")
                }.tag(5)
        }.accentColor(.mint)
    }
}
