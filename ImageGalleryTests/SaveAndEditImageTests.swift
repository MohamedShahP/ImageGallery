//
//  ImageGalleryTests.swift
//  ImageGalleryTests
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import XCTest
import ImageGallery

@testable import ImageGallery

class SaveAndEditImageTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testText_empty() {
        XCTAssertEqual(SaveAndEditImageInteractor().isTextEmpty(text: ""), true, "Text is Empty")
    }
    
    func testText_notEmpty() {
        XCTAssertEqual(SaveAndEditImageInteractor().isTextEmpty(text: "Caption and Comment"), false, "Text is not Empty")
    }

}
