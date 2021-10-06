//
//  UIApplication.swift
//  UIApplication
//
//  Created by Łukasz Stachnik on 10/09/2021.
//

import Foundation
import SwiftUI

extension UIApplication {

    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
