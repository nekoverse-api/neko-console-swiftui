//
//  ContentView.swift
//  neko-console
//
//  Created by Gary Ascuy on 12/04/25.
//

import SwiftUI
import SwiftJSONFormatter

struct ContentView: View {
    @State private var method = "POST"
    @State private var url = "https://echo.nekoverse.me/api/v1/test"
    @State private var response = ""
    @State private var data = """
{
    "name": "Gary Ascuy",
    "bio": "Software Developer, Robotics & Cats Lover, Chef Amateur",
    "stack": "SwiftUI for MacOS"
}
"""
    
    @State private var search = ""
    
    func beautify(_ json: String) -> String {
        let defaultIndent = "    "
        return SwiftJSONFormatter.beautify(json, indent: defaultIndent)
    }
    
    func sendRequest() {
        var request = URLRequest(url: URL(string: self.url)!)
        request.httpMethod = self.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = self.data.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let json = beautify(String(data: data, encoding: .utf8)!)
            self.response = json
        }
        task.resume()
    }
    
    func beautifyBody() {
        self.data = beautify(self.data)
    }
    
    func beautifyResponse() {
        self.response = beautify(self.response)
    }
    
    var body: some View {
        NavigationSplitView() {
            List {
                Text("Navigation")
                Text("Profile")
                Text("Settings")
            }
            .searchable(text: $search, prompt: "Open or Action")
            
            Spacer()
        } content: {
            VStack {
                HStack(alignment: .center) {
                    TextField("Method", text: $method)
                        .monospaced()
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                    
                    TextField("Url", text: $url)
                        .monospaced()
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Send", action: sendRequest)
                        .keyboardShortcut(.defaultAction)
                }
                
                NekoTextEditor(text: $data)
                    .monospaced()
                    .autocorrectionDisabled(true)
                    .lineSpacing(5)
                HStack {
                    Spacer()
                    Button("Beautify", action: beautifyBody)
                }
                Spacer()
            }
            .padding(.horizontal,  10)
            .padding(.vertical, 10)
        } detail: {
            VStack {
                NekoTextEditor(text: $response)
                HStack {
                    Spacer()
                    Button("Beautify", action: beautifyResponse)
                }
                    
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
        }
    }
}

#Preview {
    ContentView()
        .frame(minWidth: 500, minHeight: 500)
}
