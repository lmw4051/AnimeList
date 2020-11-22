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
  var mockSession: MockURLSession!
  var sut: JikanClient!
  
  override func setUp() {
    super.setUp()
    baseURL = URL(string: "https://api.jikan.moe/v3/top/")!
    mockSession = MockURLSession()
    sut = JikanClient(baseURL: baseURL, session: mockSession)
  }
  
  override func tearDown() {
    baseURL = nil
    mockSession = nil
    sut = nil
    super.tearDown()
  }
  
  func test_init_sets_baseURL() {
    XCTAssertEqual(sut.baseURL, baseURL)
  }
  
  func test_init_sets_session() {
    XCTAssertEqual(sut.session, mockSession)
  }
  
  func test_getTopList_callsExpectedURL() {
    // given
    let getTopListURL = URL(string: "anime", relativeTo: baseURL)!
    
    // when
    let mockTask = sut.getTopList() { _, _ in} as! MockURLSessionDataTask
    
    // then
    XCTAssertEqual(mockTask.url, getTopListURL)
  }
  
  func test_getTopList_callsResumeOnTask() {
    // when
    let mockTask = sut.getTopList { _, _ in } as! MockURLSessionDataTask
    
    // then
    XCTAssertTrue(mockTask.calledResume)
  }
}
