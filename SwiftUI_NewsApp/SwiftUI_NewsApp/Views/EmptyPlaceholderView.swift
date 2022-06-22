//
//  EmptyPlaceholderView.swift
//  SwiftUI_NewsApp
//
//  Created by Park Sungmin on 2022/06/23.
//

import SwiftUI

struct EmptyPlaceholderView: View {
    let text: String
    let image: Image?
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            Text(text)
            if let image = self.image {
                image
                    .imageScale(.large)
                    .font(.system(size: 52))
            }
            Spacer()
        }
    }
}

struct EmptyPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPlaceholderView(text: "No Bookmarks", image: Image(systemName: "bookmark"))
    }
}
