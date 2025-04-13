//
//  ContentView.swift
//  neko-console
//
//  Created by Gary Ascuy on 12/04/25.
//

import SwiftUI
import SwiftJSONFormatter

struct ContentView: View {
    @State private var method = "GET"
    @State private var url = "https://echo.nekoverse.me/api/v1/test"
    @State private var response = ""
    
    @State private var search = ""
    
    func sendRequest() {
        var request = URLRequest(url: URL(string: self.url)!)
        request.httpMethod = self.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let json = SwiftJSONFormatter.beautify(String(data: data, encoding: .utf8)!, indent: "      ")
            self.response = json
        }
        task.resume()
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
                        .frame(width: 100)
                    
                    TextField("Url", text: $url)
                    
                    Button("Send", action: sendRequest)
                }
                .padding(.horizontal,  10)
                .padding(.vertical, 10)
                
                Spacer()
            }
        } detail: {
            VStack {
                Text(response)
                    .monospaced()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
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
