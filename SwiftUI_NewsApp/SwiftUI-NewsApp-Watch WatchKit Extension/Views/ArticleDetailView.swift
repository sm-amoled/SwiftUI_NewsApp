//
//  ArticleDetailView.swift
//  SwiftUI-NewsApp-Watch WatchKit Extension
//
//  Created by Park Sungmin on 2022/06/25.
//

import SwiftUI

struct ArticleDetailView: View {
    
    let article: Article
    @EnvironmentObject private var articleBookmarkVM: ArticleBookmarkViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                AsyncImage(url: article.imageURL) { phase in
                    switch phase {
                    case .empty:
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                    case .failure:
                        HStack {
                            Spacer()
                            Image(systemName: "photo")
                                .imageScale(.large)
                            Spacer()
                        }
                        
                        
                    @unknown default:
                        fatalError()
                    }
                }
                .cornerRadius(4)
                .clipped()
                
                HStack {
                    Button {
                        articleBookmarkVM.toggleBookmark(for: article)
                    } label: {
                        Image(systemName: articleBookmarkVM.isBookmarked(for: article) ? "bookmark.fill" : "bookmark")
                            .imageScale(.large)
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.turn.up.forward.iphone")
                            .imageScale(.large)
                    }
                }
                
                Text(article.descriptionText)
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                Text(article.captionText)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetailView(article: Article.previewData[2])
            .environmentObject(ArticleBookmarkViewModel.shared)
    }
}
