//
//  HomeViewModelTests.swift
//  HomeViewModelTests
//
//  Created by Łukasz Stachnik on 11/09/2021.
//

import XCTest

@testable import SwiftyCrypto


class HomeViewModelTests: XCTestCase {
    
    let vm = HomeViewModel()
    
    override func setUpWithError() throws {
       
    }

    override func tearDownWithError() throws {
       
    }
    
    func testFiltering() throws {
        var filteredCoins = vm.filterCoins(text: "bitcoin", coins: vm.allCoins)
        XCTAssert(filteredCoins.count == 3, "Should contain 3 coins")
        
        filteredCoins = vm.filterCoins(text: "ada", coins: vm.allCoins)
        XCTAssert(filteredCoins.count == 0, "Should contain 0 coins")
    }


    

}
