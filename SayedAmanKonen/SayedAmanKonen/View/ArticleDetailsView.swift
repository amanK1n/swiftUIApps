//
//  ArticleDetailsView.swift
//  SayedAmanKonen
//
//  Created by comviva on 01/09/26.
//

import Foundation
import SwiftUI

struct ArticleDetailsView: View {
    var articleImage: Image
    @State var articleResp: Article
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
        VStack {
            articleImage
                .resizable()
                .scaledToFill()
                .frame(width: 350, height: 453)
                .clipped()
            VStack(alignment: .leading, spacing: 12) {
                Text(articleResp.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(articleResp.content)
                    .font(.body)
                
                
            }
            .padding()
        }
    }
    }
}
