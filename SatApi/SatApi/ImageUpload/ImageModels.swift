//
//  ImageModels.swift
//  SatApi
//
//  Created by comviva on 08/11/26.
//

import Foundation
// This is for base64
//struct ImageRequest : Encodable
//{
//    let attachment : String
//    let fileName : String
//}

// This is byte Array & multipart
struct ImageRequest : Encodable
{
    let attachment : Data
    let fileName : String
}


struct ImageResponse : Decodable
{
    let path: String
}
