//
//  NewsTabView.swift
//  SwiftUI_NewsApp
//
//  Created by Park Sungmin on 2022/06/22.
//

import SwiftUI

struct NewsTabView: View {
    
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    
    private var articles: [Article] {
        if case let .success(articles) = articleNewsVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    var body: some View {
        
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
            // 비동기 요청을 위해서는 task를 사용하자.
            // id : 값이 변하면 메서드를 호출함
            // id 값이 없는 경우에는 onAppear 처럼 메서드를 호출하게 됨
            // OnAppear에서 비동기처리를 하기 복잡해짐 -> task로 따로 처리하면 알아서 SwiftUI가 잘 처리해줌
                .task(id: articleNewsVM.fetchTaskToken, loadTask)
                .refreshable(action: refreshTask)
                .navigationTitle(articleNewsVM.fetchTaskToken.category.text)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        menu
                    }
                }
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch articleNewsVM.phase {
        case .empty:
            ProgressView()
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No Article", image: nil)
            
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: refreshTask)
            
        default:
            EmptyView()
        }
    }
    
    private func loadTask() async {
        await articleNewsVM.loadArticles()
    }
    
    private func refreshTask() {
        articleNewsVM.fetchTaskToken = FetchTaskToken(category: articleNewsVM.fetchTaskToken.category, token: Date())
    }
    
    private var menu: some View {
        Menu {
            Picker("Category", selection: $articleNewsVM.fetchTaskToken.category) {
                ForEach(Category.allCases) {
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "fiberchannel")
        }

    }
}



struct NewsTabView_Previews: PreviewProvider {
    static var previews: some View {
        NewsTabView(articleNewsVM: ArticleNewsViewModel(articles: Article.previewData))
    }
}
