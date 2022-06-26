//
//  SearchTabView.swift
//  SwiftUI_NewsApp
//
//  Created by Park Sungmin on 2022/06/25.
//

import SwiftUI

struct SearchTabView: View {
    
    #if os(iOS)
    @StateObject var searchVM = ArticleSearchViewModel.shared
    #elseif os(watchOS)
    @EnvironmentObject var searchVM: ArticleSearchViewModel
    #endif
    
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .navigationTitle("Search")
        }
        .searchable(text: $searchVM.searchQuery) { suggestionsView }
        .onChange(of: searchVM.searchQuery) { newValue in
            if newValue.isEmpty {
                searchVM.phase = .empty
            }
        }
        .onSubmit(of: .search, search) // searchable의 search가 onSubmin 될 때 search 함수를 호출하
        #if os(watchOS)
        .navigationTitle(searchVM.currentSearch == nil ? "Search" : "Search results for \(searchVM.currentSearch!)")
        #endif
    }
    
    private var articles: [Article] {
        if case .success(let articles) = searchVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch searchVM.phase {
        case .empty:
            #if os(iOS)
            if !searchVM.searchQuery.isEmpty {
                ProgressView()
            } else if !searchVM.history.isEmpty {
                SearchHistoryListView(searchVM: searchVM) { newValue in
                    searchVM.searchQuery = newValue
                }
            }  else {
                EmptyPlaceholderView(text: "Type your query to search from NewsAPI", image: Image(systemName: "magnifyingglass"))
            }
            #elseif os(watchOS)
                ProgressView()
            #endif
            
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No search results found", image: Image(systemName: "magnifyingglass"))
            
        case .failure(let error):
            RetryView(text: error.localizedDescription) {
                // 다시 불러오기3
            }
        default: EmptyView()
            
        }
    }
    
    @ViewBuilder
    private var suggestionsView: some View {
        ForEach(["Swift", "Covid-19", "BTS", "PS5", "iOS 15"], id: \.self) { text in
            Button {
                searchVM.searchQuery = text
            } label: {
                Text(text)
            }
        }
    }
    
    private func search() {
        let searchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchQuery.isEmpty {
            searchVM.addHistory(searchQuery)
        }
        
        async {
            await searchVM.searchArticle()
        }
    }
}

struct SearchTabView_Previews: PreviewProvider {
    @StateObject static var bookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        SearchTabView()
            .environmentObject(bookmarkVM)
    }
}
