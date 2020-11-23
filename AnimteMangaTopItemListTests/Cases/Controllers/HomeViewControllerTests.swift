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
  var mockNetworkClient: MockJikanService!
  
  // MARK: - Test Lifecycle
  override func setUp() {
    super.setUp()
    sut = HomeViewController()
  }
  
  override func tearDown() {
    mockNetworkClient = nil
    sut = nil
    super.tearDown()
  }
  
  // MARK: - Given
  func givenMockNetworkClient() {
    mockNetworkClient = MockJikanService()
    sut.networkClient = mockNetworkClient
  }
  
  func test_networkClient_setToJikanClient() {
    XCTAssertTrue((sut.networkClient as? JikanClient) === JikanClient.shared)
  }
  
  func test_loadTopItemsData_setsRequest() {
    // given
    givenMockNetworkClient()
    
    // when
    sut.loadTopItems()
    
    // then
    XCTAssertEqual(sut.dataTask, mockNetworkClient.getAnimeResultDataTask)
  }
  
  func test_loadTopListData_ifAlreadyLoading_doesntCallAgain() {
    // given
    givenMockNetworkClient()
    
    // when
    sut.loadTopItems()
    sut.loadTopItems()
    
    // then
    XCTAssertEqual(mockNetworkClient.getAnimeResultCallCount, 1)
  }
  
  func test_loadTopListData_completionNilsDataTask() {
    // given
    givenMockNetworkClient()
    
  }
}

// MARK: - Mocks
extension HomeViewControllerTests {
  class PartialMockHomeViewController: HomeViewController {
    override func loadView() {
      super.loadView()
    }
    
    var onTopListData: (() -> Void)? = nil
    
    override func loadTopItems() {
      guard let onTopListData = onTopListData else {
        super.loadTopItems()
        return
      }
      onTopListData()
    }
  }
}
