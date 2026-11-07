//
//  QueryParamsViewController.swift
//  SatApi
//
//  Created by comviva on 05/11/26.
//

import UIKit

struct MobileResponseModel: Decodable {
    let argsResponseModel: ArgsResponseModel?
    
    
    enum CodingKeys: String, CodingKey {
        case args
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.argsResponseModel = try container.decodeIfPresent(ArgsResponseModel.self, forKey: .args)
    }
}

struct ArgsResponseModel: Decodable {
    let color: String?
    let manufacturer: String?
    
    enum CodingKeys: String, CodingKey {
        case color
        case manufacturer
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.color = try container.decodeIfPresent(String.self, forKey: .color)
        self.manufacturer = try container.decodeIfPresent(String.self, forKey: .manufacturer)
    }
    
}

class QueryParamsViewController: UIViewController {
    private let httpUtility: HTTPUtility
    
    
    @IBOutlet weak var colorTextField: UITextField?
    
    @IBOutlet weak var manufacturerTextField: UITextField?
    
    @IBOutlet weak var resultLable: UILabel?
    var color: String = ""
    var manufacturer: String = ""
    
    init(_ httpUtiliy: HTTPUtility) {
        self.httpUtility = httpUtiliy
        super.init(nibName: "QueryParamsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        
        self.httpUtility = HTTPUtility()
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        colorTextField?.placeholder = "Color"
        manufacturerTextField?.placeholder = "Manufacturer"
        resultLable?.numberOfLines = 0
    }
    
    @IBAction func simpleQueryCall(_ sender: Any) {
        self.color = colorTextField?.text ?? ""
        self.manufacturer = manufacturerTextField?.text ?? ""
        print(color)
        print(manufacturer)
        // EX-3 --> Create a struct for Example 3
        struct PhoneReq: Encodable {
            let color: String
            let manufacturer: String
        }
       let phoneReq = PhoneReq(color: self.color, manufacturer: self.manufacturer)
        
        
        
        // Ex-1
        // let encodedColor = createPercentageEncoded(from: color)!
        // let encodedManufacturer = createPercentageEncoded(from: manufacturer)!
        // let urlString = URL(string: "https://free.mockerapi.com/get?color=\(encodedColor)&manufacturer=\(encodedManufacturer)")
        
        // Ex-2
//        let urlString = "https://free.mockerapi.com/get"
//        let url = URL(string: urlString)!
//        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
//        components?.queryItems = [URLQueryItem(name: "color", value: self.color),
//                                  URLQueryItem(name: "manufacturer", value: self.manufacturer)]
//        
//        print("Compl url: ", components?.url)
        
        // Ex-3
        let urlString = "https://free.mockerapi.com/get"
        let url = URL(string: urlString)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = phoneReq.convertToURLQueryItems()
        
        httpUtility.getApiData(requestURL: (components?.url!)!, resultType: MobileResponseModel.self) { result in
            print(result.argsResponseModel?.color)
            print(result.argsResponseModel?.manufacturer)
            DispatchQueue.main.async {
                let res = (result.argsResponseModel?.color ?? "") + " n " + (result.argsResponseModel?.manufacturer ?? "") + ":)"
                print(res)
                self.resultLable?.text = res
            }
            
            
        }
        
    }
    func createPercentageEncoded(from value: String) -> String? {
        return value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    

}


extension Encodable {
    func convertToURLQueryItems() -> [URLQueryItem]? {
        do {
            let encoder = try JSONEncoder().encode(self)
            let requestDictionary = (try? JSONSerialization.jsonObject(with: encoder, options: .allowFragments)).flatMap { $0 as? [String:Any?] }
            if requestDictionary != nil {
                var queryItems: [URLQueryItem] = []
                requestDictionary?.forEach { (key: String, value: Any?) in
                    if value != nil {
                        let strValue = value as? String
                        if let val = strValue {
                            queryItems.append(URLQueryItem(name: key, value: val))
                        }
                    }
                }
                return queryItems
            }
            
            
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
}
