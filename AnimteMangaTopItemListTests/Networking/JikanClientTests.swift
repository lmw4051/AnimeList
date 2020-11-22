//
//  JikanClientTests.swift
//  AnimteMangaTopItemListTests
//
//  Created by David on 2020/11/22.
//  Copyright © 2020 David. All rights reserved.
//

import XCTest
@testable import AnimteMangaTopItemList

class JikanClientTests: XCTestCase {
  var baseURL: URL!
  var session: URLSession!
  var sut: JikanClient!
  
  override func setUp() {
    super.setUp()
    baseURL = URL(string: "https://api.jikan.moe/v3/top/")!
    session = URLSession.shared
    sut = JikanClient(baseURL: baseURL, session: session)
  }
  
  override func tearDown() {
    baseURL = nil
    session = nil
    sut = nil
    super.tearDown()
  }
  
  func test_init_sets_baseURL() {
    XCTAssertEqual(sut.baseURL, baseURL)
  }
  
  func test_init_sets_session() {    
    XCTAssertEqual(sut.session, session)
  }
}
