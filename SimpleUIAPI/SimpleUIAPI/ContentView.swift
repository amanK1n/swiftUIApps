//
//  ContentView.swift
//  SimpleUIAPI
//
//  Created by comviva on 31/08/26.
//

import SwiftUI

struct ContentView: View {
    @State var result: Dictionary<String, Any>?
    @State var result2: [String:Any] = [:]
    var body: some View {
        NavigationView {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Call API") {
                callAPI()
            }
            
                Text("\(result)")
            ApiCallView(result2: $result2)
           
                Text("2nd API call RESPONSE")
                Text("\(result2)")
            NavigationLink(destination: RegFormView()) {
                Text("Click to Register")
                    .frame(width: 200, height: 40, alignment: .center)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .cornerRadius(10)
            }
            
        }
        .padding()
       
            
        }
    }
    func callAPI() {
        let session = URLSession.shared
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                return
            }
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 200 {
                let jsonData = try? JSONSerialization.jsonObject(with: data ?? Data(), options: .mutableContainers)
                
                DispatchQueue.main.async {
                    self.result = (jsonData as? Dictionary<String, Any>)!
                    print(self.result)
                }
                
            }
            
        }
        task.resume()
    }
}

