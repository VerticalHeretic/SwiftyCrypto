//
//  ErrorPublisherProtocol.swift
//  ErrorPublisherProtocol
//
//  Created by Lukasz Stachnik on 17/09/2021.
//

import Foundation

protocol ErrorPublishedProtocol {
    var errorPublisher: Published<Error?> { get }
    var isErrorPublisher: Published<Bool> { get }
    func showError(error: Error)
}
