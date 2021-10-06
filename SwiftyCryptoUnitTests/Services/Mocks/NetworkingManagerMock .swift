//
//  NetworkingManagerMock .swift
//  NetworkingManagerMock 
//
//  Created by Łukasz Stachnik on 24/09/2021.
//

import Foundation
import Combine

struct NetworkingManagerMock: DataProvider {

    var result: Result<Data, NetworkingManager.NetworkingError>

    func fetch(url: URL) -> AnyPublisher<Data, NetworkingManager.NetworkingError> {
        result.publisher
            .eraseToAnyPublisher()
    }

}
