//
//  ContentView.swift
//  RMAMaker
//
//  Created by Sayed on 18/03/26.
//

import SwiftUI
internal import Combine
enum AppTheme: String {
    case system, light, dark
}

struct ContentView: View {
    @State private var requestJSON: String = ""
    @State private var responseJSON: String = ""
    @State private var rootName: String = ""
    @State public var outputCode: String = ""
    @State private var aiAnalysisResult: String = ""
    @State private var isLoading = false
    @State private var folderURL: URL?
    @State private var selectedTheme: AppTheme = .system
    @Environment(\.colorScheme) private var systemScheme
    @State private var refreshID = UUID()
    @StateObject private var themeManager = ThemeManager()
    
    var effectiveScheme: ColorScheme? {
        switch selectedTheme {
        case .system:
            return systemScheme
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    init() {
        loadFonts()
    }
    var body: some View {
        ZStack {
            
            ScrollView {   // 👈 wrap everything
                
                VStack(spacing: 0) {
                    
                    // MARK: - Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("AI RMA Code Generator")
                                .font(.custom("Roboto-Bold", size: 28))
                            
                            Text("Generate production-ready models using AI intelligence")
                                .font(.custom("Roboto-Regular", size: 12))
                                
                        }
                        
                        Spacer()
                        
                            
                            HStack {
                                Button("System") { themeManager.theme = .system }
                                Button("Light")  { themeManager.theme = .light }
                                Button("Dark")   { themeManager.theme = .dark }
                            }
                        
                        .preferredColorScheme(effectiveScheme)
                        ZStack {
                            Image(systemScheme == .dark ? "logo_white_text" : "logo_black_text")
                                .frame(height: 0)
                                .scaledToFit()
                        }
                    }
                    // MARK: - Input Section
                    HStack(spacing: 16) {
                        
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Label("Request JSON", systemImage: "arrow.up.doc")
                                    .font(.custom("Roboto-Regular", size: 20))
                                
                                Spacer()
                                
                                MainContentView(requestJSON: $requestJSON, responseJSON: $responseJSON)
                                
                                Button {
                                    if let pasted = NSPasteboard.general.string(forType: .string) {
                                        requestJSON = pasted
                                    }
                                } label: {
                                    Label("Paste", systemImage: "doc.on.clipboard")
                                        .font(.custom("Roboto-Regular", size: 18))
                                }
                                
                                Button {
                                    requestJSON = ""
                                } label: {
                                    Label("Clear", systemImage: "xmark.circle")
                                        .font(.custom("Roboto-Regular", size: 20))
                                }
                            }
                            
                            TextEditor(text: $requestJSON)
                                .frame(minHeight: 150) // 👈 important inside ScrollView
                                .font(.system(.body, design: .monospaced))
                                .padding(8)
                                .background(Color(NSColor.textBackgroundColor))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                        }
                        
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Label("Response JSON", systemImage: "arrow.down.doc")
                                    .font(.custom("Roboto-Regular", size: 20))
                                
                                Spacer()
                                
                                Button {
                                    if let pasted = NSPasteboard.general.string(forType: .string) {
                                       
                                        responseJSON = pasted
                                    }
                                } label: {
                                    Label("Paste", systemImage: "doc.on.clipboard")
                                        .font(.custom("Roboto-Regular", size: 18))
                                    
                                }
                                
                                Button {
                                    responseJSON = ""
                                } label: {
                                    Label("Clear", systemImage: "xmark.circle")
                                        .font(.custom("Roboto-Regular", size: 20))
                                }
                            }
                            
                            TextEditor(text: $responseJSON)
                                .frame(minHeight: 150) // 👈 important
                                .font(.system(.body, design: .monospaced))
                                .padding(8)
                                .background(Color(NSColor.textBackgroundColor))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                        }
                    }.padding(.top, 20)
                    
                    // ❌ REMOVE THIS (important)
                     .frame(height: 390)
                    
                    
                    // MARK: - Root Name + AI Controls
                    HStack(spacing: 12) {
                        
                        
                        TextField("Root Name (e.g. Person)", text: $rootName)
                            .textFieldStyle(.plain)
                            .padding(.vertical, 10)       // 👈 controls height
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4))
                            )
                            .frame(width: 280)
                            .padding()
                        
                        
                        Button {
                            suggestRootName(
                                rootName: &rootName,
                                requestJSON: requestJSON,
                                responseJSON: responseJSON
                            )
                        } label: {
                            Label("Suggest Name", systemImage: "wand.and.stars")
                                .font(.custom("Roboto-Regular", size: 18))
                        }
                        
                        Spacer()
                    }.padding(.leading, -15)
                    
                    ActionButtonsView(
                        rootName: $rootName,
                        outputCode: $outputCode,
                        requestJSON: $requestJSON,
                        responseJSON: $responseJSON,
                        aiAnalysisResult: $aiAnalysisResult,
                        isLoading: $isLoading,
                        folderURL: $folderURL
                    )
                    
                    // MARK: - Output Header
                    HStack {
                        Text("Output Generated")
                            .font(.custom("Roboto-Regular", size: 18))
                        
                        Spacer()
                        
                        if let folderURL = folderURL,
                           FileManager.default.fileExists(atPath: folderURL.path) {
                            
                            Button {
                                openFolder(at: folderURL)
                            } label: {
                                Label("Open Folder", systemImage: "folder")
                            }
                        }
                    }.padding(.bottom)
                    
                    // MARK: - Output Viewer
                    ScrollView { // 👈 inner scroll still fine
                        Text(outputCode)
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                    .frame(maxHeight: 200)
                    .background(Color.black.opacity(0.03))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                }
                .padding()
            }
            
            // Loader overlay
            if isLoading {
                AILoaderView()
                    
            }
            
        }
        .frame(minWidth: 950, minHeight: 720)
        .disabled(isLoading)
        .animation(.easeInOut, value: isLoading)
        .environmentObject(themeManager)
        .preferredColorScheme(themeManager.colorScheme)
    }
    func themeButton(title: String, theme: AppTheme) -> some View {
        Button(title) {
            setTheme(theme)
        }
        .padding()
        .background(selectedTheme == theme ? Color.blue : Color.gray.opacity(0.2))
        .foregroundColor(selectedTheme == theme ? .white : .primary)
        .cornerRadius(8)
    }
    func setTheme(_ theme: AppTheme) {
        selectedTheme = theme
        
        // 👇 Force full UI refresh
        DispatchQueue.main.async {
            refreshID = UUID()
        }
    }
  
    func openFolder(at url: URL) {
        
        NSWorkspace.shared.open(url)
    }
    

    func loadFonts() {
        let fontURLs = Bundle.main.urls(forResourcesWithExtension: "ttf", subdirectory: nil) ?? []
        
        for url in fontURLs {
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
    
    
    
    
    
    
}


#Preview {
    ContentView()
}
class ThemeManager: ObservableObject {
    
    @Published var theme: AppTheme = .system
    
    var colorScheme: ColorScheme? {
        switch theme {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
