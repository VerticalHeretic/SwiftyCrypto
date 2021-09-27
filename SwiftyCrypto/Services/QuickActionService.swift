//
//  QuickActionService.swift
//  QuickActionService
//
//  Created by Łukasz Stachnik on 27/09/2021.
//

import Foundation

/**
 Enum of app's QuickAction types
 */
enum QuickAction : String {
    case protfolio, about
}

final class QuickActionService : ObservableObject {
    
    @Published var action: QuickAction?
    
    init(initialValue: QuickAction? = nil) {
        Info.debug("Initialized with \(initialValue?.rawValue)")
        action = initialValue
    }
    
}
