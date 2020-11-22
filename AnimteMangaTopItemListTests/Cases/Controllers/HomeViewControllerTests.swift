//
//  HomeViewControllerTests.swift
//  AnimteMangaTopItemListTests
//
//  Created by David on 2020/11/22.
//  Copyright © 2020 David. All rights reserved.
//

import XCTest
@testable import AnimteMangaTopItemList

class HomeViewControllerTests: XCTestCase {
  // MARK: - Instance Properties
  var sut: HomeViewController!
  
  // MARK: - Test Lifecycle
  override func setUp() {
    super.setUp()
    sut = HomeViewController()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  func test_networkClient_setToJikanClient() {
    XCTAssertTrue(sut.networkClient === JikanClient.shared)
  }
}
