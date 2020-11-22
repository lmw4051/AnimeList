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
  
  var getTopListURL: URL {
    return URL(string: "anime", relativeTo: baseURL)!
  }
  
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
  
  func whenGetAnimeItems(
    data: Data? = nil,
    statusCode: Int = 200,
    error: NSError? = nil) -> (calledCompletion: Bool, animeItems: [AnimeItem]?, error: Error?) {
    
    let response = HTTPURLResponse(url: getTopListURL,
                                   statusCode: statusCode,
                                   httpVersion: nil,
                                   headerFields: nil)
    
    // when
    var calledCompletion = false
    var receivedAnimeItems: [AnimeItem]? = nil
    var receivedError: Error? = nil
    
    let mockTask = sut.getTopList { animeItems, error in
      calledCompletion = true
      receivedAnimeItems = animeItems
      receivedError = error as NSError?
    } as! MockURLSessionDataTask
    
    mockTask.completionHandler(data, response, error)
    return (calledCompletion, receivedAnimeItems, receivedError)
  }
  
  func test_init_sets_baseURL() {
    XCTAssertEqual(sut.baseURL, baseURL)
  }
  
  func test_init_sets_session() {
    XCTAssertEqual(sut.session, mockSession)
  }
  
  func test_getTopList_callsExpectedURL() {
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
  
  func test_getTopList_givenResponseStatusCode500_callsCompletion() {
    let result = whenGetAnimeItems(statusCode: 500)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.animeItems)
    XCTAssertNil(result.error)
  }
  
  func test_getTopList_givenError_callsCompletionWithError() throws {
    // given
    let expectedError = NSError(domain: "com.AnimeItemsTests", code: 0)
    
    // when
    let result = whenGetAnimeItems(error: expectedError)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.animeItems)
    
    let actualError = try XCTUnwrap(result.error as NSError?)
    XCTAssertEqual(actualError, expectedError)
  }
}