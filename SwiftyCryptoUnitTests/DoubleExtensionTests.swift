//
//  DoubleExtensionTests.swift
//  SwiftyCryptoUnitTests
//
//  Created by Łukasz Stachnik on 19/07/2021.
//

import XCTest


@testable import SwiftyCrypto

class DoubleExtensionTests: XCTestCase {

    let testDoubles = [1234.56, 12.3456, 123.1234567]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAsCurrencyWith6Decimals() throws {
        let testStrings = ["€1,234.56", "€12.3456", "€123.123457"]
        
        for (index, element) in testDoubles.enumerated() {
            let got = element.asCurrencyWith6Decimals()
            
            XCTAssertEqual(got, testStrings[index], "After formatting double: \(element) should be equal \(testStrings[index]), but got \(got)")
        }
    }
    
    func testAsCurrencyWith2Decimals() throws {
        let testStrings = ["€1,234.56", "€12.35", "€123.12"]
        
        for (index, element) in testDoubles.enumerated() {
            let got = element.asCurrencyWith2Decimals()
            
            XCTAssertEqual(got, testStrings[index], "After formatting double: \(element) should be equal \(testStrings[index]), but got \(got)")
        }
    }
    
    func testAsNumberString() throws {
        let testStrings = ["1234.56", "12.35", "123.12"]
        
        for (index, element) in testDoubles.enumerated() {
            let got = element.asNumberString()
            
            XCTAssertEqual(got, testStrings[index], "After formatting double: \(element) should be equal \(testStrings[index]), but got \(got)")
        }
    }
    
    func testAsPercentString() throws {
        let testStrings = ["1234.56%", "12.35%", "123.12%"]
        
        for (index, element) in testDoubles.enumerated() {
            let got = element.asPercentString()
            
            XCTAssertEqual(got, testStrings[index], "After formatting double: \(element) should be equal \(testStrings[index]), but got \(got)")
        }
    }

}
