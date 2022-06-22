//
//  ArticleListView.swift
//  SwiftUI_NewsApp
//
//  Created by Park Sungmin on 2022/06/22.
//

import SwiftUI

struct ArticleListView: View {
    
    let articles: [Article]
    @State private var selectedArticle: Article?
    
    var body: some View {
        List {
            ForEach(articles) { article in
                ArticleRowView(article: article)
                    .onTapGesture {
                        selectedArticle = article
                    }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .sheet(item: $selectedArticle) {
            SafariView(url: $0.articleURL)
                .edgesIgnoringSafeArea(.bottom)
        }

    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView(articles: Article.previewData)
    }
}