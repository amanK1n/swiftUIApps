//
//  HomeView.swift
//  SayedAmanKonen
//
//  Created by comviva on 01/09/26.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State var apiResponse: [String:Any] = [:]
    @ObservedObject var articleViewModel: ArticleViewModel = ArticleViewModel()
    @State var articleResp: [Article] = []
    var body: some View {
        NavigationStack {
           
        VStack {
            
            HStack {
                Image("alkyle_logo")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                Text("TEST")
                    .font(.system(size: 20, weight: .heavy, design: .default))
                    .foregroundStyle(.black)
            }.padding(20)
            
            Text("alkyle")
                .font(.system(size: 40, weight: .heavy, design: .default))
                .foregroundStyle(.black)
            Text("The easiest test you will ever do")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
                .padding(.bottom, 20)
            
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(articleViewModel.articles) { article in
                            
                            VStack {
                                ZStack {
                                    AsyncImage(url: URL(string: article.image_url)) { phase in
                                        switch phase {
                                        case .success(let image):
                                            NavigationLink(destination: ArticleDetailsView(articleImage: image, articleResp: article)) {
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 350, height: 453)
                                                    .clipped()
                                                
                                            }
                                        case .empty:
                                            Image(systemName: "photo.fill")
                                                .font(.system(size: 60))
                                                .foregroundColor(.white)
                                        case .failure:
                                            Image(systemName: "photo.fill")
                                                .font(.system(size: 60))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    VStack(alignment: .leading) {
                                        Spacer()
                                        Text(article.prompt)
                                            .padding()
                                            .frame(width: 150, height: 30, alignment: .leading)
                                            .background(.black)
                                            .foregroundStyle(.white)
                                            .cornerRadius(15)
                                        
                                        Text(article.short_description)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding()
                                        
                                    }.padding()
                                    
                                }
                            }
                            .frame(width: 350, height: 453)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.gray.opacity(0.8),
                                        Color.black.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(12)
                        
                    }
                    }
                    .padding(.horizontal)
                }
            }
        
            Spacer()
//            Text("\(apiResponse)")
            Tabbar()
                .frame(width: 400, height: 30, alignment: .center)
        }.onAppear {
           // ApiCall(apiResponse: $apiResponse).callArticleAPI()
//            ArticleViewModel(articles).callArticleAPI()
            
                
            DispatchQueue.main.async {
                articleViewModel.callArticleAPI()
                articleResp = articleViewModel.articles
                print("home")
                print("\(articleResp)")
            }
        }
    }
}

struct Tabbar: View {
    @State var selectedTag: Int = -1
    var body: some View {
        TabView(selection: $selectedTag) {
            InfoView()
                .tabItem {
                    VStack {
                        Image("info_icon")
                            .resizable()
                            .frame(width: 10, height: 10)
                        
                    }
                }.tag(0)
            MenuView()
                .tabItem {
                    VStack {
                        Image("menu_icon")
                            .resizable()
                            .frame(width: 10, height: 10)
                        
                    }
                }.tag(1)
            ProfileView()
                .tabItem {
                    VStack {
                        Image("profile_icon")
                            .resizable()
                            .frame(width: 10, height: 10)
                        
                    }
                }.tag(2)
            
            
        }
        
        
    }
}
