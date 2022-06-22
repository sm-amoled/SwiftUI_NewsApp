//
//  RetryView.swift
//  SwiftUI_NewsApp
//
//  Created by Park Sungmin on 2022/06/23.
//

import SwiftUI

struct RetryView: View {
    
    let text: String
    let retryAction: () -> ()
    
    var body: some View {
        VStack(spacing: 8) {
            Text(text)
                .font(.callout)
                .multilineTextAlignment(.center)
            
            Button(action: retryAction) {
                Text("Try again")
            }
            
        }
    }
}
