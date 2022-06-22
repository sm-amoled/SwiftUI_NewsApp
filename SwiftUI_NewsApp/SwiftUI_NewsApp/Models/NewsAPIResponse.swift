//
//  NewsAPIResponse.swift
//  SwiftUI_NewsApp
//
//  Created by Park Sungmin on 2022/06/22.
//

import Foundation

struct NewsAPIResponse: Decodable {
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    // Error 발생 시 전달되는 값
    let code: String?
    let message: String?
}
