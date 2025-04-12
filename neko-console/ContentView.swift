//
//  ContentView.swift
//  neko-console
//
//  Created by Gary Ascuy on 12/04/25.
//

import SwiftUI

struct ContentView: View {
    @State private var method = ""
    @State private var url = ""
    @State private var response = ""
    
    func sendRequest() {
        let url = URL(string: "https://echo.nekoverse.me/api/v1/test")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            self.response = String(data: data, encoding: .utf8)!
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
            
            Text(method + " " + url)
            Text(response)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .frame(minWidth: 500, minHeight: 500)
}
