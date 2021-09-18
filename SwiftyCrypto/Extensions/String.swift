//
//  String.swift
//  String
//
//  Created by Łukasz Stachnik on 18/09/2021.
//

import Foundation

extension String {
    
    var removingHTMLOccurances : String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
