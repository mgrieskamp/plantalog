//
//  Theme.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 7/29/23.
//

import SwiftUI

enum Theme: String {
    case forest
    case asparagus
    case celadon
    case beaver
    case bistre
    case rose
    
    var accentColor: Color {
        switch self {
        case .forest, .bistre: return Color(Theme.celadon.rawValue)
        case .asparagus, .beaver, .celadon, .rose: return Color(Theme.bistre.rawValue)
        }
    }
    
    var mainColor: Color {
        Color(rawValue)
    }
}

