//
//  Untitled.swift
//  SimpleUIAPI
//
//  Created by comviva on 31/08/26.
//
import SwiftUI
struct RegFormView: View {
    @State private var userName: String = ""
    @State private var password: String = ""
    var body: some View {
        Text("Fill the Form to Register")
            .font(.headline)
        TextField("Enter Username", text: $userName)
            .foregroundStyle(.gray)
            .cornerRadius(10)
            .padding()
        SecureField("Enter Password", text: $password)
            .foregroundStyle(.gray)
            .cornerRadius(10)
            .padding()
        Button {
//            debugPrint("Tapped!!")
//            debugPrint("Username: \(userName)")
//            debugPrint("Password: \(password)")
            User().callRegApi()
        } label: {
            Text("Register")
                .frame(width: 200, height: 40, alignment: .center)
                .foregroundStyle(.white)
                .background(.blue)
                .cornerRadius(10)
                .padding()
        }//.disabled(userName.count < 3 || password.count < 3)

        
    }
}

struct User {
    
    func callRegApi() {
        print("Call post api")
        var urlRequest = URLRequest(url: URL(string: Endpoints.registerUser)!)
        urlRequest.httpMethod = "POST"
        let dataDict = ["name":"aman", "email":"aman@gmail.com","password":"12345"]
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
            urlRequest.httpBody = requestBody
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {return}
            debugPrint(response.statusCode)
            debugPrint(data)
            dump(data)
            if response.statusCode == 200 {
                if data != nil {
                    let response = String(data: data ?? Data(), encoding: .utf8)
                    print(response)
                }
            }
        }
        task.resume()
        
    }
}



struct Endpoints {
    static let registerUser = "https://api-dev-scus-demo.azurewebsites.net/api/User/RegisterUser"
    static let getUser = "https://api-dev-scus-demo.azurewebsites.net/api/User/GetUser"
}
