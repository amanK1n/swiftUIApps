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
    @EnvironmentObject public var themeManager: ThemeManager
    @Environment(\.colorScheme) private var systemScheme
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("AI Agent Test Cases Generator").font(.custom("Roboto-Bold", size: 28))
                        Text("Generate production-ready testcases using AI intelligence").font(.custom("Roboto-Regular", size: 12))
                    }
                    Spacer()
                    Button(action: {
                        print("key::", APIKeyManager.get())
                        agent.showAPIKeyPopup = true
                        print("api key clicked")
                    }) {
                        Text("API Key")
                    }
                    Button("☀") {
                        themeManager.theme = .light
                        
                    }
                    
                    
                    Button("⏾") {
                        themeManager.theme = .dark
                        
                    }
                    ZStack {
                        //                    if systemScheme == .dark {
                        //                        SparklingLogo(systemScheme: .dark)
                        //                            .preferredColorScheme(.dark)
                        //                    } else {
                        //                        SparklingLogo(systemScheme: .light)
                        //                            .preferredColorScheme(.light)
                        //                    }
                        
                        Image(systemScheme == .dark ? "logo_white_text" : "logo_black_text")
                            .frame(height: 0)
                            .scaledToFit()
                    }.padding(.init(top: 20, leading: 0, bottom: 50, trailing: 0) )
                    
                }
                TextField("Feature / Module Name (Optional)", text: $featureName)
                    .font(.custom("Roboto-Regular", size: 16))
                    .onChange(of: featureName) { agent.featureName = $0 }
                HStack {
                    Button {
                        openPicker()
                    } label: {
                        Text("Upload Screenshots")
                            .font(.custom("Roboto-Regular", size: 16))
                    }.padding(.top)
                    
                    if !agent.testCases.isEmpty {
                        Button {
                            self.featureName = ""
                            self.screenshots = []
                            agent.testCases = []
                            agent.screenshots = []
                            agent.featureName = ""
                        } label: {
                            Text("Test New module")
                                .font(.custom("Roboto-Regular", size: 16))
                        }.padding(.top)
                    }
                    
                    
                }
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach($screenshots) { $item in
                            VStack {
                                
                                ZStack(alignment: .topTrailing) {
                                    Image(nsImage: item.image)
                                        .resizable()
                                        .frame(width: 100, height: 200)
                                        .cornerRadius(8)
                                        .border(.foreground, width: 2.0)
                                    
                                    Button(action: {
                                        removeScreenshot(item)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .background(Color.white.clipShape(Circle()))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .offset(x: 8, y: 0)
                                }
                                
                                ZStack(alignment: .topLeading) {
                                    if item.description.isEmpty {
                                        Text("Description(Optional)")
                                            .foregroundColor(.gray)
                                            .padding(.top, 8)
                                            .padding(.leading, 2)
                                            .zIndex(1)
                                    }
                                    TextEditor(text: $item.description)
                                        .padding(8)
                                }
                                .frame(width: 150, height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5))
                                )
                            }
                        }
                    }
                }.padding()
                Button(action: {
                    if screenshots.isEmpty {
                        agent.showError = true
                        agent.errorMessage = "Please select atleast one screenshot"
                    } else {
                        agent.screenshots = screenshots
                        agent.run()
                    }
                }) {
                    Text("Run AI Agent")
                        .font(.custom("Roboto-Regular", size: 16))
                }.padding(.all)
                    .buttonStyle(.borderedProminent)
                    .tint(Color(hex: "#08F177"))
                
                
                List(agent.testCases) { t in
                    VStack(alignment: .leading) {
                        Text(t.title).bold()
                        Text(t.steps)
                        Text(t.expectedResult)
                    }
                }
                
                
            }.disabled(isLoading ?? false)
            if isLoading ?? false {
                AILoaderView()
                    .transition(.opacity) // optional: smooth fade-in/out
                    .zIndex(1) // make sure it's above other content
            }
            EmptyView().modifier(PopupModifier(
                isPresented: $agent.showError,
                    title: "Something went wrong",
                    message: agent.errorMessage
                ))
        }.onAppear {
            agent.isLoading = { isLoading in
                self.isLoading = isLoading
            }
            
        }
        .frame(minWidth: 700, idealWidth: 950, maxWidth: .infinity, minHeight: 600, idealHeight: 720, maxHeight: .infinity, alignment: .center)
        .padding()
        .overlay (
            
            APIKeyPromptView(isPresented: $agent.showAPIKeyPopup) { key in
                APIKeyManager.save(key)
            }
        )
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
