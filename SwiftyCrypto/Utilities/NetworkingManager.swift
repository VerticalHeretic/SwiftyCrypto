//
//  NetworkingManager.swift
//  NetworkingManager
//
//  Created by Łukasz Stachnik on 08/09/2021.
//

import Foundation
import Combine

final class NetworkingManager: DataProvider {

    enum NetworkingError: LocalizedError {

        case url(URLError?)
        case badResponse(statusCode: Int)
        case unknown(Error)

        var errorDescription: String? {
            switch self {
            case .badResponse(statusCode: let statusCode):
                return "Bad response \(statusCode)"
            case .unknown:
                return "Unknown error occured"
            case .url(let error):
                return "URL error occured: \(error.debugDescription)"
            }
        }

        static func convert(error: Error) -> NetworkingError {
            switch error {
            case let error as URLError:
                return .url(error)
            case let error as NetworkingError:
                return error
            default:
                return .unknown(error)
            }
        }

    }

    func fetch(url: URL) -> AnyPublisher<Data, NetworkingError> {
       return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ (data, response) -> Data in
                if let response = response as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                    throw NetworkingError.badResponse(statusCode: response.statusCode)
                } else {
                    return data
                }
            })
            .mapError({ error in
                NetworkingError.convert(error: error)
            })
            .eraseToAnyPublisher()
    }

}
