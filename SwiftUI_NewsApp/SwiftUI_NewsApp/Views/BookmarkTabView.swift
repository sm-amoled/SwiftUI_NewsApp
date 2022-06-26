//
//  BookmarkTabView.swift
//  SwiftUI_NewsApp
//
//  Created by Park Sungmin on 2022/06/24.
//

import SwiftUI

struct BookmarkTabView: View {
    
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    @State var searchText: String = ""
    
    var body: some View {
        let articles = self.articles
        
        ArticleListView(articles: articles)
            .overlay(overlayView(isEmpty: articles.isEmpty))
            .navigationTitle("Saved Articles")
            #if os(watchOS)
            .conditionalSearchable(showSearchbar: !articles.isEmpty, searchText: $searchText)
            #else
            .searchable(text: $searchText)
            #endif
    }
    
    private var articles: [Article] {
        if searchText.isEmpty {
            return articleBookmarkVM.bookmarks
        }
        
        return articleBookmarkVM.bookmarks
            .filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.descriptionText.lowercased().contains(searchText.lowercased())
            }
    }
    
    @ViewBuilder
    func overlayView(isEmpty: Bool) -> some View {
        if isEmpty {
            EmptyPlaceholderView(text: "No saved articles", image: Image(systemName: "bookmark"))
        }
    }
}

#if os(watchOS)
fileprivate extension View {
    @ViewBuilder
    func conditionalSearchable(showSearchbar: Bool, searchText: Binding<String>) -> some View {
        if showSearchbar {
            searchable(text: searchText)
        } else {
            self
        }
    }
}
#endif

struct BookmarkTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkTabView()
    }
}
