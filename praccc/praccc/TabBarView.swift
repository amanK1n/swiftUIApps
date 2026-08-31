//
//  TabBarView.swift
//  praccc
//
//  Created by comviva on 31/08/26.
//
import SwiftUI
struct TabBarView: View {
    @State private var defaultTabIndex: Int = 1
    var completeFavList: [CompleteFavList]
    var body: some View {
        TabView(selection: $defaultTabIndex) {
            FavItemsView(completeFavList: completeFavList)
                .tabItem {
                    Text("Notes")
                    Image(systemName: "pencil")
                }.tag(0)
            HomeView()
                .tabItem {
                    Text("Home")
                    Image(systemName: "house")
                    
                }.tag(1)
            SearchView()
                .tabItem {
                    Text("Search")
                    Image(systemName: "magnifyingglass")
                    
                }.tag(2)
        }
    }
}
struct HomeView: View {
    var body: some View {
        Text("HOME")
            .font(.headline)
    }
}
struct SearchView: View {
    var body: some View {
        Text("SEARCH")
            .font(.largeTitle)
    }
}
