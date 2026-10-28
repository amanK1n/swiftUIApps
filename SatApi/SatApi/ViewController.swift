//
//  ViewController.swift
//  SatApi
//
//  Created by comviva on 24/10/26.
//

import UIKit

struct Endpoint {
    static let todosEndpoint = "https://jsonplaceholder.typicode.com/todos/1" // VIDEO 1
    static let registerUser = "http://api-dev-scus-demo.azurewebsites.net/api/User/RegisterUser" // VIDEO 2
    static let getUser = "http://api-dev-scus-demo.azurewebsites.net/api/User/GetUser" // VIDEO 2
    static let employeesEndpoint = "https://free.mockerapi.com/mock/e6e0104d-448d-4e31-a330-69609bfaf710" // VIDEO 4
    
}

struct UserId: Codable {
    let id: Int
    let name: String
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}


class ViewController: UIViewController {

    private let httpUtility: HTTPUtility = HTTPUtility()
//    init(_httpUtility: HTTPUtility) {
//        httpUtility = _httpUtility
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        self.httpUtility = HTTPUtility()
//        super.init(coder: coder)
//    }
    
  
    @IBAction func getButtonAction(_ sender: Any) {
        executeVid1API()
    }
    
    
    @IBAction func postBtnAction(_ sender: Any) {
        callPostApi()
    }
    
    
    @IBAction func getUserApiAction(_ sender: Any) {
        callGetUserApi()
    }
    
    
    @IBAction func encodablePOSTAPICallAction(_ sender: Any) {
        encodablePostApiCall()
    }
    
    
    @IBAction func decodablePOSTAPICallAction(_ sender: Any) {
        decodablePostApiCall()
    }
    
    
    @IBAction func usingGenericsAPICallAction(_ sender: Any) {
        let url = URL(string: Endpoint.employeesEndpoint)
        httpUtility.getApiData(requestURL: url!) { (result: EmployeeResponseModel) in
            print(result.id)
            print(result.depid)
            print(result.joining)
            print(result.name)
            print(result.role)
            print(result.salary)
            print(result.workPhone)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}



// VIDEO 1: URLSession: Api parsing swift example for beginners with JSONSerialization
extension ViewController {
    func executeVid1API() {
        let session = URLSession.shared
        let serviceURL = URL(string: Endpoint.todosEndpoint)
        session.dataTask(with: serviceURL!) { data, response, error in
            if let error = error {
                print("Error::\(error)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            switch response.statusCode {
            case 200...203:
                let jsonData = try? JSONSerialization.jsonObject(with: data ?? Data(), options: .mutableContainers)
                let result = jsonData as? Dictionary<String,Any>
                print("userId: \(result?["userId"] ?? "")")
                print("id: \(result?["id"] ?? "")")
                print("title: \(result?["title"] ?? "")")
                print("completed: \(result?["completed"] ?? "")")
                
            case 401:
                print("Un-authorized!!")
            default:
                print("Error!!")
            }
            
        }.resume()
    }
}

// VIDEO 2: URLSession POST request in swift for beginners in Hindi | JSON POST API in swift
extension ViewController {
    
    func callPostApi() {
        let dictionary = ["name":"aman", "email": "aman@mail.com", "password": "1234"]
        
        var urlRequest = URLRequest(url: URL(string: Endpoint.registerUser)!)
        do {
           
            let reqBody = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
           
            urlRequest.httpMethod = "post"
            urlRequest.httpBody = reqBody
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
          
            
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        let urlSession = URLSession.shared
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Erorr::occured\(error.localizedDescription)")
                return
            }
            guard let resp = response as? HTTPURLResponse else {
                print("responeeeeeeee____rrrr nonoooonooonoonnono")
                return
            }
            
            switch resp.statusCode {
            case (200...203):
              
                if data != nil, data?.count != 0 {
                    let jsonResp = try? JSONSerialization.jsonObject(with: data ?? Data())
                    let resp = jsonResp as? Dictionary<String, Any>
                    dump(resp)
                    let resStr = String(data: data!, encoding: .utf8)
                    dump(resStr)
                    
                }
                
            case 401:
                print("Un-auth")
            default:
                print("errror occured")
            }
        }.resume()
        
        
    }
    
    func callGetUserApi() {
        let urlRequest = URLRequest(url: URL(string: Endpoint.getUser)!)
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Error in if let:: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Response:: \(response)")
                return
            }
            switch response.statusCode {
            case (200...204):
                print("succcesss")
                let jsonData = try? JSONSerialization.jsonObject(with: data ?? Data())
                let result = jsonData as? [Dictionary<String, Any>]
                print(result ?? [])
//                let resStr = String(data: data!, encoding: .utf8)
//                print(resStr)
            case 401:
                print("un-authh")
            default:
                print("erreeerrr in defauklt")
            }
            
        }.resume()
    }
}


// VIDEO 3: Encodable in swift | Encodable with POST JSON API swift tutorial hindi
extension ViewController {
    // REQUEST MODEL ---------------------->>>>>>
    struct UserRegistrationRequest: Encodable {
        let name, email, password: String
       
        enum CodingKeys: String, CodingKey {
          case name, email, password
        }
    }
    // ------------------------------------>>>>>>
    struct UserRegistrationResponse: Decodable {
        let errorMessage: String
        let data: UserData
    }
    struct UserData: Decodable {
        let name, email, id, joining: String
    }
    
    func encodablePostApiCall() {
        var urlRequest = URLRequest(url: URL(string: Endpoint.registerUser)!)
        let request = UserRegistrationRequest(name: "Aman", email: "aman@mail.com", password: "1234")
        
        
        
    
        do {
            let requestBody = try JSONEncoder().encode(request)
            urlRequest.httpMethod = "post"
            urlRequest.httpBody = requestBody
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        } catch let error {
            debugPrint(error)
        }
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Error::\(error)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("Error in response")
                return
            }
            
            switch response.statusCode {
            case (200...203):
//                let jsonObj = try? JSONSerialization.jsonObject(with: data ?? Data())
//                let response = jsonObj as? Dictionary<String, Any>
//               dump(response)
                do {
                    let result = try JSONDecoder().decode(UserRegistrationResponse.self, from: data ?? Data())
                    dump(result)
                } catch let error {
                    debugPrint(error)
                }
                
            case 401:
                print("Un-authorized access")
            default:
                print("Error in response")
            }
            
            
        }.resume()
    }
}
