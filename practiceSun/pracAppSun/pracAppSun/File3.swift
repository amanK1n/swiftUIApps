//
//  File3.swift
//  pracAppSun
//
//  Created by comviva on 27/09/26.
//
import SwiftUI
struct File3: View {
    @State private var isPlaying: Bool = false
    @State private var playStatus: String = "Not Playing"
    
    var body: some View {
        Button {
            
            self.isPlaying.toggle()
            playStatus = self.isPlaying ? "Playing" : "Not Playing"
            debugPrint("Btn tapped: \(playStatus)")
        } label: {
            VStack {
                Image(systemName: isPlaying ? "pause" : "play")
                    .resizable()
                    .frame(width: 60, height: 60, alignment: .center)
                Text(playStatus)
                    .font(.headline)
                .padding()
            }
        }

    }
}
