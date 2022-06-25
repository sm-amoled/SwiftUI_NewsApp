//
//  Cateogry.swift
//  SwiftUI_NewsApp
//
//  Created by Park Sungmin on 2022/06/22.
//

import Foundation

enum Category: String, CaseIterable {
    case general
    case business
    case entertainment
    case health
    case science
    case sports
    case technology
    
    var text: String {
        if self == .general {
            return "Top headlines"
        }
        return rawValue.capitalized
    }
    
    var systemImage: String {
        switch self {
        case .general:
            return "newspaper"
        case .business:
            return "building.2"
        case .technology:
            return "desktopcomputer"
        case .entertainment:
            return "tv"
        case .sports:
            return "sportscourt"
        case .science:
            return "wave.3.right"
        case .health:
            return "cross"
        }
    }
}

extension Category: Identifiable {
    var id: Self { self }
}
