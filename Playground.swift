import Playgrounds
import Foundation

//https://fake-json-api.mock.beeceptor.com/companies

func getData() async {
    print("Inside getDDAatta(())")
    let session = URLSession.shared
    let serviceURL = URL(string: "https://fake-json-api.mock.beeceptor.com/companies")
    let task = session.dataTask(with: serviceURL!) { (data, resp, error) in
        if let error = error {
            print("Error occured: \(error)")
            return
        }
        guard let httpResponse = resp as? HTTPURLResponse else {
            return
        }
         
        switch httpResponse.statusCode {
        case 200...204:
            print("success")
            let jsonData = try? JSONSerialization.jsonObject(with: data ?? Data(), options: .mutableContainers)
            print(jsonData)
        case 401:
            print("eroror")
        default:
            print("def error")
        }
        
    }
    task.resume()
}
#Playground {
    print("Hello, Playground!aaaaa")
   await getData()
    print("Hello, Playground!BBBBB")
}
