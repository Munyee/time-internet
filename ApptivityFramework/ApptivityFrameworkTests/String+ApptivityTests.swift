//
//  String+ApptivityTests.swift
//  ApptivityFramework
//
//  Created by AppLab on 18/05/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import XCTest

class String_ApptivityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testNameInitials() {
        let firstNameOnly: String = "Adam"
        XCTAssertTrue(firstNameOnly.nameInitials == "A")

        let firstNameOnlyUnclean: String = " Adam "
        XCTAssertTrue(firstNameOnlyUnclean.nameInitials == "A")

        let firstNameLastName: String = "John Appleseed"
        XCTAssertTrue(firstNameLastName.nameInitials == "JA")

        let withMiddleName: String = "Bob Johnson Kennedy"
        XCTAssertTrue(withMiddleName.nameInitials == "BK")

        let withSpecialCharacters: String = "(Bob) Johnson @ Kennedy"
        XCTAssertTrue(withSpecialCharacters.nameInitials == "BK")

        let withSpecialCharacters2: String = "@ (Johnson) Kennedy"
        XCTAssertTrue(withSpecialCharacters2.nameInitials == "JK")
    }

    func testQRCodeImage() {
        let testString = "Hello world!"
        let QRImage = testString.QRImage(withScale: UIScreen.main.scale)

        XCTAssertNotNil(QRImage)
    }

    func testPassIntegerValidationFromString() {
        let integerValueString = "1234"
        let negativeIntegerValueString = "-1234"
        XCTAssertTrue((integerValueString.intValue != nil && negativeIntegerValueString.intValue != nil), "Input String is not an Int")

        let decimalIntegerString = "17"
        XCTAssertTrue((decimalIntegerString.intValue != nil), "Input String is not an Int")
    }

    func testFailIntegerValidationFromString() {
        let doubleString = "-12.34"
        XCTAssertFalse((doubleString.intValue != nil), "Input String is an Int")

        let symbolString = "/12.3\\@4+"
        XCTAssertFalse((symbolString.intValue != nil), "Input String is an Int")

        let floatString = "1.21875e1"
        XCTAssertTrue((Float(floatString) != nil), "Input String is a Float")
        XCTAssertFalse((floatString.intValue != nil), "Input String is not an Int")

        let binaryInteger = 0b10001
        let binaryIntegerInString = String(describing: binaryInteger)
        XCTAssertTrue((Int(binaryIntegerInString) != nil), "Input String should be an Int")

        let binaryIntegerByString = "0b10001"
        XCTAssertFalse((Int(binaryIntegerByString) != nil), "Input String should not be an Int")
    }

    func testSafePasswordCheck() {
        let unsafePassword1: String = "abcdef"
        XCTAssertFalse(unsafePassword1.isSafePassword(ofLength: 6))

        let unsafePassword2: String = "123456"
        XCTAssertFalse(unsafePassword2.isSafePassword(ofLength: 6))

        let safePassword1: String = "abc456"
        XCTAssertTrue(safePassword1.isSafePassword(ofLength: 6))

        let safePassword2: String = "456abc"
        XCTAssertTrue(safePassword2.isSafePassword(ofLength: 6))

        let safePassword3: String = "ab456a"
        XCTAssertTrue(safePassword3.isSafePassword(ofLength: 6))

        let safePassword4: String = "123@ab"
        XCTAssertTrue(safePassword4.isSafePassword(ofLength: 6))
    }

    func testSubstring() {
        let loremIpsum = "lorem ipsum librador retriever"

        XCTAssert(loremIpsum.substring(to: 5) == "lorem", "substring should == lorem")
        XCTAssert(loremIpsum.substring(from: 12) == "librador retriever", "substring should == librador retriever")

        XCTAssert(loremIpsum.substring(with: 6..<11) == "ipsum", "substring should == ipsum")
    }
}
