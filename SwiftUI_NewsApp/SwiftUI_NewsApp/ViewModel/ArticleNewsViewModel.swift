//
//  ArticleNewsViewModel.swift
//  SwiftUI_NewsApp
//
//  Created by Park Sungmin on 2022/06/22.
//

import SwiftUI

enum DataFetchPhase<T> {
    case empty
    case success(T)
    case failure(Error)
}

struct FetchTaskToken: Equatable {
    var category: Category
    var token: Date
}

@MainActor
class ArticleNewsViewModel: ObservableObject {
    
    @Published var phase = DataFetchPhase<[Article]>.empty
    @Published var fetchTaskToken: FetchTaskToken
//    let articles = [Article]
//    let isFetching = false
//    let error: Error
    
    private let newsAPI = NewsAPI.shared
    
    init(articles: [Article]? = nil, selectedCategory: Category = .general) {
        if let articles = articles {
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
    }
    
    func loadArticles() async {
        phase = .success(Article.previewData)
        
        if Task.isCancelled { return }
        phase = .empty
        
        do {
            let articles = try await newsAPI.fetch(from: fetchTaskToken.category)
            if Task.isCancelled { return }
            phase = .success(articles)
//            DispatchQueue.main.async { }
//            MainActor 를 사용해 Dispatch Queue를 사용해줄 필요가 없다.
            
        } catch {
            if Task.isCancelled { return }
            phase = .failure(error)
            print(error.localizedDescription)
        }
        
    }
    
}
