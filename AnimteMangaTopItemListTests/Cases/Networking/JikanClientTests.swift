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
    return URL(string: "anime/1/airing", relativeTo: baseURL)!
  }
  
  // MARK: - Test Lifecycle
  override func setUp() {
    super.setUp()
    baseURL = URL(string: "https://api.jikan.moe/v3/top/")!
    mockSession = MockURLSession()
    sut = JikanClient(baseURL: baseURL,
                      session: mockSession,
                      responseQueue: nil)
  }
  
  override func tearDown() {
    baseURL = nil
    mockSession = nil
    sut = nil
    super.tearDown()
  }
  
  // MARK: - When
  func whenGetTopList(
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
        
    let mockTask = sut.getTopList(type: "anime", subType: "airing", page: 1) { animeResult, error in
      calledCompletion = true
      receivedAnimeItems = animeResult?.top
      receivedError = error as NSError?
    } as! MockURLSessionDataTask
    
    mockTask.completionHandler(data, response, error)
    return (calledCompletion, receivedAnimeItems, receivedError)
  }
  
  // MARK: - Then
  func verifyGetTopListDispatchedToMain(
    data: Data? = nil,
    statusCode: Int = 200,
    error: Error? = nil,
    line: UInt = #line) {
    mockSession.givenDispatchQueue()
    sut = JikanClient(baseURL: baseURL,
                      session: mockSession,
                      responseQueue: .main)
    
    let expectation = self.expectation(description: "Completion wasn't called")
    
    // when
    var thread: Thread!
    let mockTask = sut.getTopList(type: "anime", subType: "airing", page: 1) { animeResult, error in
      thread = Thread.current
      expectation.fulfill()
    } as! MockURLSessionDataTask
    
    let response = HTTPURLResponse(url: getTopListURL,
                                   statusCode: 200,
                                   httpVersion: nil,
                                   headerFields: nil)
    
    mockTask.completionHandler(nil, response, error)
    
    // then
    waitForExpectations(timeout: 0.2) { _ in
      XCTAssertTrue(thread.isMainThread, line: line)
    }
  }
  
  // MARK: - Object Lifecycle - Tests
  func test_init_sets_baseURL() {
    XCTAssertEqual(sut.baseURL, baseURL)
  }
  
  func test_init_sets_session() {
    XCTAssertEqual(sut.session, mockSession)
  }
  
  func test_init_sets_responseQueue() {
    // given
    let responseQueue = DispatchQueue.main
    
    // when
    sut = JikanClient(baseURL: baseURL,
                      session: mockSession,
                      responseQueue: responseQueue)
    
    // then
    XCTAssertEqual(sut.responseQueue, responseQueue)
  }
  
  func test_getTopList_callsExpectedURL() {
    // when
    let mockTask = sut.getTopList(type: "anime", subType: "airing", page: 1) { _, _ in } as! MockURLSessionDataTask
    
    // then
    XCTAssertEqual(mockTask.url, getTopListURL)
  }
  
  func test_getTopList_callsResumeOnTask() {
    // when
    let mockTask = sut.getTopList(type: "anime", subType: "airing", page: 1) { _, _ in } as! MockURLSessionDataTask
    
    // then
    XCTAssertTrue(mockTask.calledResume)
  }
  
  func test_getTopList_givenResponseStatusCode500_callsCompletion() {
    let result = whenGetTopList(statusCode: 500)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.animeItems)
    XCTAssertNil(result.error)
  }
  
  func test_getTopList_givenError_callsCompletionWithError() throws {
    // given
    let expectedError = NSError(domain: "com.AnimeResultTests", code: 0)
    
    // when
    let result = whenGetTopList(error: expectedError)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.animeItems)
    
    let actualError = try XCTUnwrap(result.error as NSError?)
    XCTAssertEqual(actualError, expectedError)
  }
  
  func test_getTopList_givenValidJSON_callsCompletionWithAnimeResult() throws {
    // given
    let data = try Data.fromJSON(fileName: "GET_AnimeResult_ValidResponse")
    let decoder = JSONDecoder()
    let animeResult = try decoder.decode(AnimeResult.self, from: data)
    
    // when
    let result = whenGetTopList(data: data)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertEqual(result.animeItems, animeResult.top)
    XCTAssertNil(result.error)
  }
  
  func test_getTopList_givenInValidJSON_callsCompletionWithError() throws {
    // given
    let data = try Data.fromJSON(fileName: "GET_MissingValues_Response")
    var expectedError: NSError!
    
    let decoder = JSONDecoder()
    
    do {
      _ = try decoder.decode(AnimeResult.self, from: data)
    } catch {
      expectedError = error as NSError
    }
    
    // when
    let result = whenGetTopList(data: data)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.animeItems)
    
    let actualError = try XCTUnwrap(result.error as NSError?)
    XCTAssertEqual(actualError.domain, expectedError.domain)
    XCTAssertEqual(actualError.code, expectedError.code)
  }
  
  func test_getTopList_givenHTTPStatusError_dispatchesToResponseQueue() {
    verifyGetTopListDispatchedToMain(statusCode: 500)
  }
  
  func test_getTopList_givenError_dispatchesToResponseQueue() {
    // given
    let error = NSError(domain: "com.AnimeResultTests", code: 0)
    
    // then
    verifyGetTopListDispatchedToMain(error: error)
  }
  
  func test_getTopList_givenGoodResponse_dispatchesToResponseQueue() throws {
    // given
    let data = try Data.fromJSON(fileName: "GET_AnimeResult_ValidResponse")
    
    // then
    verifyGetTopListDispatchedToMain(data: data)
  }
  
  func test_getTopList_givenInvalidResponse_dispatchesToResponseQueue() throws {
    // given
    let data = try Data.fromJSON(fileName: "GET_MissingValues_Response")
    
    // then
    verifyGetTopListDispatchedToMain(data: data)
  }
}
