//
//  ImageManager.swift
//  SatApi
//
//  Created by comviva on 08/11/26.
//


import Foundation
struct Endpoints
{
    static let uploadImage = "https://api-dev-scus-demo.azurewebsites.net/api/Image/UploadImage"
    static let uploadImageWithByteArray = "https://api-dev-scus-demo.azurewebsites.net/api/Image/UploadImageWithByteArray"
    static let uploadImageMultiPartForm = "https://api-dev-scus-demo.azurewebsites.net/api/Image/UploadImageMultiPartForm"
}

// Use this endpoint for your code challenge.
struct ChallengeEndpoint
{
    static let multiPart = "https://api-dev-scus-demo.azurewebsites.net/api/Employee/MultiPartCodeChallenge"
}

struct ImageManager {
    func uploadImage(data: Data, completionHandler: @escaping(_ result: ImageResponse) -> Void) {
        
        let request = ImageRequest(attachment: data, fileName: "ByteArrayExample")
        do {
            let requestBody = try JSONEncoder().encode(request)
            let httpUtility = ImageUploadUtility()
            let requestURL = URL(string: Endpoints.uploadImage)!
            httpUtility.postAPIData(requestUrl: requestURL, requestBody: requestBody, responseBody: ImageResponse.self) { result in
                debugPrint("Got callback in ImageManager")
                debugPrint(result.path)
                completionHandler(result)
            }
            
        } catch let error {
            debugPrint(error)
        }
        
    }
}
