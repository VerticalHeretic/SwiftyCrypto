//
//  CoinImageServiceTests.swift
//  CoinImageServiceTests
//
//  Created by Łukasz Stachnik on 24/09/2021.
//

import Foundation
import XCTest
import Combine

@testable import SwiftyCrypto

class CoinImageServiceTests : XCTestCase {
    
    lazy var mockCoins : [Coin] = {
        return [Coin.testableCoin]
    }()

    var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions = []
    }
    
    func testLoadingCoinsAtLaunch() throws {
        let data = try JSONEncoder().encode(mockCoins)
        let mock = NetworkingManagerMock(result: .success(data))
        let service = CoinImageService(networkingManager: mock)
        XCTAssertEqual(service.allCoins.count,0, "starting with no coins")
        
        let promise = expectation(description: "loading 1 coin")
        service.$allCoins
            .drop { coins in
                coins.count == 0
            }
            .contains(where: { (coins) in
                Info.debug("🪙: \(coins.count)")
                return coins.count == 1
              
            })
            .sink(receiveValue: { (value) in
                promise.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [promise], timeout: 1)
    }
    
    func testError() throws {
        let mock = NetworkingManagerMock(result: .failure(NetworkingManager.NetworkingError.badResponse(statusCode: 400)))
        let service = CoinDataService(networkingManager: mock)
        XCTAssertEqual(service.allCoins.count,0, "starting with no coins")
        
        
        service.$serviceIsActive
            .filter({
                !$0 //is not active
            })
            .first()
            .sink { (value) in
                XCTFail("data stream to fetch did complete")
            }
            .store(in: &subscriptions)
        
        let promise = expectation(description: "should get error message")
        
        service.$error
            .filter({ error in
                error != nil
            })
            .first()
            .sink { (message) in
                promise.fulfill()
            }
            .store(in: &subscriptions)
        wait(for: [promise], timeout: 1)
    }
    
}
