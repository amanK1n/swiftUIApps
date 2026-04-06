//
//  ContentView.swift
//  AutoQA
//
//  Created by Sayed on 27/03/26.
//

import SwiftUI
internal import UniformTypeIdentifiers


struct ContentView: View {
    @StateObject var agent = AIAgent()
    @State private var screenshots: [ScreenshotItem] = []
    @State private var featureName = ""
    @State private var isLoading: Bool?
    var body: some View {
        VStack {
            Text("AI Agent Test Generator").font(.largeTitle)

            TextField("Feature / Module Name (Optional)", text: $featureName)
                .onChange(of: featureName) { agent.featureName = $0 }

            Button("Upload Screenshots") {
                openPicker()
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach($screenshots) { $item in
                        VStack {
                            
                            ZStack(alignment: .topTrailing) {
                                Image(nsImage: item.image)
                                    .resizable()
                                    .frame(width: 150, height: 100)
                                    .cornerRadius(8)

                                Button(action: {
                                    removeScreenshot(item)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .background(Color.white.clipShape(Circle()))
                                }
                                .buttonStyle(PlainButtonStyle())
                                .offset(x: 8, y: -8)
                            }

                            TextField("Description (Optional)", text: $item.description)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 150)
                        }
                    }
                }
            }
            Button(action: {
                agent.screenshots = screenshots
                agent.run()
                
            }) {
                HStack {
                    Text("Run AI Agent")
                }.padding()
            }
            
            if isLoading ?? false {
                AILoaderView()
            }
            List(agent.testCases) { t in
                VStack(alignment: .leading) {
                    Text(t.title).bold()
                    Text(t.steps)
                    Text(t.expectedResult)
                }
            }
           
        }.onAppear {
            agent.isLoading = { isLoading in
                self.isLoading = isLoading
            }
        }.disabled(isLoading ?? false)
        .frame(width: .infinity, height: .infinity)
        .padding()
    }
        
    func removeScreenshot(_ item: ScreenshotItem) {
        screenshots.removeAll { $0.id == item.id }
    }
    func openPicker() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.png, .jpeg]
        panel.allowsMultipleSelection = true

        if panel.runModal() == .OK {
            for url in panel.urls {
                if let img = NSImage(contentsOf: url) {
                    screenshots.append(ScreenshotItem(image: img, description: ""))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
