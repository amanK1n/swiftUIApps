//
//  File7.swift
//  pracAppSun
//
//  Created by comviva on 03/10/26.
//

import Foundation
import SwiftUI

struct File7: View {
    
    var body: some View {
        @State var defaultSelection: Int = 2
        VStack {
            TabView(selection: $defaultSelection) {
                HomeeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(0)
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }.tag(1)
                    
                PlayView()
                    .tabItem {
                        Image(systemName: "play")
                        Text("Play")
                    }.tag(2)

                NoteView()
                    .tabItem {
                        Image(systemName: "pencil")
                        Text("Note")
                    }.tag(3)

                
                MessageView()
                    .tabItem {
                        Image(systemName: "message")
                        Text("Message")
                    }.tag(4)

                
            }.accentColor(.cyan)
            
           
        }.navigationBarTitle("Tabbar Demo",displayMode: .inline)
        
        
    }
    
}


struct HomeeView: View {
    var body: some View {
        Text("HOME VIEW")
            .font(.largeTitle)
    }
}

struct SearchView: View {
    var body: some View {
        Text("Search VIEW")
            .font(.largeTitle)
    }
}

struct PlayView: View {
    var body: some View {
        Text("PLAY VIEW")
            .font(.largeTitle)
    }
}

struct NoteView: View {
    var body: some View {
        Text("NOTE VIEW")
            .font(.largeTitle)
    }
}

struct MessageView: View {
    var body: some View {
        Text("Msg VIEW")
            .font(.largeTitle)
    }
}

