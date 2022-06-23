//
//  ArticleBookmarkViewModel.swift
//  SwiftUI_NewsApp
//
//  Created by Park Sungmin on 2022/06/24.
//

import Foundation

@MainActor
class ArticleBookmarkViewModel: ObservableObject {
    
    @Published private(set) var bookmarks: [Article] = []
    
    // array에 first 사용
    // 제일 앞에서부터 뒤로 순서대로 원소를 탐색함
    // 탐색을 위한 클로저를 매개변수로 가짐
    func isBookmarked(for article: Article) -> Bool {
        // article의 ID 값과, boookmarks 리스트의 원소의 ID를 비교함.
        // 같은 id가 있으면 해당 원소를 반환함
        bookmarks.first { article.id == $0.id } != nil
    }
    
    func addBookmark(for article: Article) {
        // 북마크의 결과가 true라면 처리하지 않기
        guard isBookmarked(for: article) != true else {
            return
        }
        
        bookmarks.insert(article, at: 0)
    }
    
    func removeBookmark(for article: Article) {
        // Bookmark에서 아티클의 id를 찾아 index를 가져오기
        guard let index = bookmarks.firstIndex(where: { $0.id == article.id }) else {
            return
        }
        bookmarks.remove(at: index)
    }
}

