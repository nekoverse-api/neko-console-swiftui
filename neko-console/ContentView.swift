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
        VStack(alignment: .leading) {
            HStack (alignment: .center){
                TextField("Method", text: $method)
                    .frame(width: 100)
                
                TextField("Url", text: $url)
                
                Button("Send", action: sendRequest)
            }.padding(10)

            Text(response).padding(10)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .frame(minWidth: 500, minHeight: 500)
}
