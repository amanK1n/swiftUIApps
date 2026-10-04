//
//  File8.swift
//  pracAppSun
//
//  Created by comviva on 04/10/26.
//

import SwiftUI

struct File8: View {
    let teams = BundleDecoder.decodeIPLJSON()
    @State private var searchBarText: String = String()
    var body: some View {
        VStack {
            SearchBarView(searchBarText: $searchBarText)
            List {
                ForEach(teams.filter({searchBarText.isEmpty ? true : $0.name.contains(searchBarText)}), id: \.id) { team in
                    RowView(team: team)
                }
            }
        }
    }

}

struct RowView: View {
    var team: IPLTeams
    var body: some View {
        HStack(spacing: 20) {
            Image(team.icon)
                .resizable()
                .frame(width: 50, height: 50, alignment: .leading)
            RowContentView(team: team)

        }.padding()
    }
}

struct RowContentView: View {
    var team: IPLTeams
    var body: some View {
        VStack(alignment: .leading) {
            Text(team.name)
                .font(.title2)
                .fontWeight(.regular)
                .lineLimit(1)
            RowWinnerView(team: team)
        }
    }
}

struct RowWinnerView: View {
    var team: IPLTeams
    var body: some View {
        if team.winners != "" {
            HStack {
                Image("trophy")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 20,
                        height: 20,
                        alignment: .leading
                    )
                Text(team.winners)
                    .font(.subheadline)
                    .foregroundStyle(.yellow)
                    .fontWeight(.bold)

            }.padding()
                .background(Capsule().fill(Color.black)).opacity(0.7)
                .overlay(Capsule().stroke(Color.black, lineWidth: 1))

        }
    }
}

struct SearchBarView: UIViewRepresentable {
    @Binding var searchBarText: String
    typealias UIViewType = UISearchBar

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var searchBarValue: String
        init(text: Binding<String>) {
            _searchBarValue = text
        }

        func searchBar(
            _ searchBar: UISearchBar,
            textDidChange searchText: String
        ) {
            debugPrint("Coord-searchBar-textDidChange")
            
            searchBarValue = searchText
        }
    }

    func makeCoordinator() -> Coordinator {
        debugPrint("Making coord")
        return Coordinator(text: $searchBarText)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = context.coordinator
        debugPrint("makeUIView")
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        debugPrint("updateUIView")
        uiView.text = searchBarText
    }
}
