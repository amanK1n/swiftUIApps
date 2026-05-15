//
//  ContentView.swift
//  AIQATestRunner
//
//  Created by Sayed on 16/04/26.
//

import SwiftUI

struct ContentView: View {
    @State private var generationMode: FlowGenerationMode = .offline
    @State private var geminiAPIKey: String
    @State private var appId = ""
    @State private var flowDescription = ""
    @State private var generatedYAML = ""
    @State private var statusMessage = ""
    @State private var errorMessage = ""
    @State private var savedFilePath = ""
    @State private var isGenerating = false
    
    @State private var featureName: String = ""
    @State private var isLoading = false
    @State private var screenshots: [ScreenshotItem] = []
    @State private var testSteps: [TestStep] = []

    init() {
        _geminiAPIKey = State(initialValue: ProcessInfo.processInfo.environment["GEMINI_API_KEY"] ?? "")
        loadFonts()
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    actionSection
                    TestStepsGenerator(featureName: $featureName, screenshots: $screenshots, isLoading: $isLoading, testSteps: $testSteps, flowDescription: $flowDescription)
                    generatorSection
                    generatedPreviewSection
                }
                .padding()
            }
        }
        .frame(minWidth: 760, minHeight: 640)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("AI QA Test Automation Suite Runner")
                .font(.custom("Roboto-Bold", size: 28))

            Text("Run Automation Suites Hassle Free With AI")
                .font(.custom("Roboto-Regular", size: 12))
                .foregroundStyle(.secondary)
        }
    }

    private var actionSection: some View {
        HStack(spacing: 12) {
            Button("Boot Simulator") {
                bootSimulator()
            }

            Button("Run Automation suite") {
                runAutomationRunner()
            }
        }
    }

    private var generatorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Generate YAML")
                .font(.custom("Roboto-Bold", size: 18))

            VStack(alignment: .leading, spacing: 8) {
                Text("Mode")
                    .font(.custom("Roboto-Bold", size: 14))

                Picker("Mode", selection: $generationMode) {
                    ForEach(FlowGenerationMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }

            if generationMode == .online {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Gemini API Key")
                        .font(.custom("Roboto-Bold", size: 14))

                    SecureField("Paste your Gemini API key", text: $geminiAPIKey)
                        .textFieldStyle(.roundedBorder)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("App ID")
                    .font(.custom("Roboto-Bold", size: 14))

                TextField("Enter the app bundle id, for example com.company.app", text: $appId)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Flow Description")
                    .font(.custom("Roboto-Bold", size: 14))

                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(NSColor.textBackgroundColor))

                    if flowDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text("Describe the full flow in plain English. Example: Launch the app, tap Login, enter username and password, submit, verify the dashboard is visible.")
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 16)
                    }

                    TextEditor(text: $flowDescription)
                        .scrollContentBackground(.hidden)
                        .padding(8)
                        .font(.system(.body, design: .monospaced))
                }
                .frame(minHeight: 220)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
            }

            HStack(spacing: 12) {
                Button {
                    Task {
                        await generateAndSaveFlow()
                    }
                } label: {
                    if isGenerating {
                        Label("Generating...", systemImage: "sparkles")
                    } else {
                        Label("Generate YAML", systemImage: "sparkles")
                    }
                }
                .disabled(isGenerating)

                if isGenerating {
                    ProgressView()
                        .controlSize(.small)
                }
            }

            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .foregroundStyle(.secondary)
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            if !savedFilePath.isEmpty {
                Text("Saved YAML to \(savedFilePath)")
                    .foregroundStyle(.green)
                    .textSelection(.enabled)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(NSColor.windowBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
        )
    }

    @ViewBuilder
    private var generatedPreviewSection: some View {
        if !generatedYAML.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Generated YAML Preview")
                    .font(.custom("Roboto-Bold", size: 18))

                ScrollView {
                    Text(generatedYAML)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(.body, design: .monospaced))
                        .textSelection(.enabled)
                        .padding()
                }
                .frame(minHeight: 220)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(NSColor.textBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
                )
            }
        }
    }

    @MainActor
    private func generateAndSaveFlow() async {
        let description = flowDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let apiKey = geminiAPIKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let enteredAppId = appId.trimmingCharacters(in: .whitespacesAndNewlines)

        errorMessage = ""
        savedFilePath = ""

        guard !description.isEmpty else {
            statusMessage = ""
            errorMessage = "Enter a flow description before generating YAML."
            return
        }

        guard !enteredAppId.isEmpty else {
            statusMessage = ""
            errorMessage = "Enter the app ID before generating YAML."
            return
        }

        if generationMode == .online && apiKey.isEmpty {
            statusMessage = ""
            errorMessage = "Enter your Gemini API key before generating YAML."
            return
        }

        isGenerating = true
        statusMessage = generationMode == .online
            ? "Generating Maestro YAML from your description..."
            : "Generating Maestro YAML locally in offline mode..."

        do {
            let yaml: String

            if generationMode == .online {
                yaml = try await generateOnlineMaestroYAML(
                    flowDescription: description,
                    appId: enteredAppId,
                    apiKey: apiKey
                )
            } else {
                yaml = try generateOfflineMaestroYAML(
                    flowDescription: description,
                    appId: enteredAppId
                )
            }

            generatedYAML = yaml

            statusMessage = "YAML generated. Choose the name and folder in the macOS save dialog."

            let savedURL = try saveGeneratedYAMLToUserSelectedLocation(
                yaml,
                suggestedFileName: suggestedFileName(from: description)
            )

            savedFilePath = savedURL.path
            statusMessage = "Maestro YAML generated and saved successfully."
        } catch FlowGenerationError.userCancelledSave {
            statusMessage = "YAML generated, but save was cancelled."
        } catch {
            statusMessage = ""
            errorMessage = error.localizedDescription
        }

        isGenerating = false
    }

    private func suggestedFileName(from description: String) -> String {
        let words = description
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }

        let fileName = words.prefix(6).joined(separator: "-")
        return fileName.isEmpty ? "generated-maestro-flow" : fileName
    }

    private func loadFonts() {
        let fontURLs = Bundle.main.urls(forResourcesWithExtension: "ttf", subdirectory: nil) ?? []

        for url in fontURLs {
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}
