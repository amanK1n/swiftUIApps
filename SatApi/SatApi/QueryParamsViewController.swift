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
    }
    
    @IBAction func simpleQueryCall(_ sender: Any) {
        self.color = colorTextField?.text ?? ""
        self.manufacturer = manufacturerTextField?.text ?? ""
        print(color)
        print(manufacturer)
        let encodedColor = createPercentageEncoded(from: color)!
        let encodedManufacturer = createPercentageEncoded(from: manufacturer)!
        let urlString = URL(string: "https://free.mockerapi.com/get?color=\(encodedColor)&manufacturer=\(encodedManufacturer)")
        
        print("Compl url: ", urlString)
        
        httpUtility.getApiData(requestURL: urlString!, resultType: MobileResponseModel.self) { result in
            print(result.argsResponseModel?.color)
            print(result.argsResponseModel?.manufacturer)
        }
        
    }
    func createPercentageEncoded(from value: String) -> String? {
        return value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    


}
