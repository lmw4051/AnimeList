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
  var sut: JikanClient!
  
  
  func test_init_sets_baseURL() {
    // given
    let baseURL = URL(string: "https://api.jikan.moe/v3/top/")!
    let session = URLSession.shared
    
    // when
    sut = JikanClient(baseURL: baseURL, session: session)
    
    // then
    XCTAssertEqual(sut.baseURL, baseURL)
  }
  
  func test_init_sets_session() {
    // given
    let baseURL = URL(string: "https://api.jikan.moe/v3/top/")!
    let session = URLSession.shared
    
    // when
    sut = JikanClient(baseURL: baseURL, session: session)
    XCTAssertEqual(sut.session, session)
  }
}
