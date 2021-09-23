//
//  RedditFeedViewModelTests.swift
//  CodeChallengeTests
//
//  Created by Jordon Bowen on 9/22/21.
//

import XCTest
import Combine
@testable import CodeChallenge

class RedditFeedViewModelTests: XCTestCase {

    var viewModel: RedditFeedViewModel!
    var cancellable: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = RedditFeedViewModel(repository: MockRepository())
        cancellable = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        cancellable = nil
        try super.tearDownWithError()
    }

    /*
     viewModel?
         .feedBinding
         .dropFirst()
         .receive(on: RunLoop.main).sink {[weak self] _ in
             print("AAA: Reloading Tableview")
             self?.tableView.reloadData()
         }.store(in: &cancellabel)

     viewModel?
         .errorBinding
         .dropFirst()
         .receive(on: DispatchQueue.main).sink { _ in
             // Handle error here for user
         }.store(in: &cancellabel)
     */
    
    func testGetFeedDataSuccess() {
        // Arrange
        let expectation = XCTestExpectation(description: "Successfully got data")
        viewModel.after = "success"
        
        // Act
        viewModel?
            .feedBinding
            .dropFirst()
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &cancellable)
        
        viewModel?
            .errorBinding
            .dropFirst()
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { _ in
                XCTFail()
            })
            .store(in: &cancellable)
        viewModel?.getRedditFeeds()
        wait(for: [expectation], timeout: 3)
        
        // Asssert
        XCTAssertEqual(viewModel.numberOfItems, 25)
        XCTAssertEqual(viewModel.getTitle(at: 0), "A nanobot picks up a lazy sperm by the tail and inseminates an egg with it")
        XCTAssertEqual(viewModel.getCommentNumber(at: 0), "# comment: 2587")
        XCTAssertEqual(viewModel.getScore(at: 0), "score: 32860")
    }
    
    func testGetFeedDataFailure() {
        let expectation = XCTestExpectation(description: "Failed to get data")
        var error: String?
        
        // Act
        viewModel?
            .feedBinding
            .dropFirst()
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { _ in
                XCTFail()
            })
            .store(in: &cancellable)
        
        viewModel?
            .errorBinding
            .dropFirst()
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { value in
                error = value
                expectation.fulfill()
            })
            .store(in: &cancellable)
        viewModel?.getRedditFeeds()
        wait(for: [expectation], timeout: 3)
        
        XCTAssertEqual(error, "The operation couldn’t be completed. (CodeChallenge.NetworkError error 1.)")
    }

}


// MARK: Mock RedditFeedRepositoryService to inject
