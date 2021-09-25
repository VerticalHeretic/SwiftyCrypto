//
//  DataProvider.swift
//  DataProvider
//
//  Created by Łukasz Stachnik on 24/09/2021.
//

import Foundation
import Combine

protocol DataProvider {
    func fetch(url: URL) -> AnyPublisher<Data, NetworkingManager.NetworkingError>
}
