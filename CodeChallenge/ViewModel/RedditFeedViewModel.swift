//
//  RedditFeedViewModel.swift
//  CodeChallenge
//
//  Created by Jordon Bowen on 9/22/21.
//

import Foundation

protocol RedditFeedViewModelType {
    var feedBinding: Published<[ChildData]>.Publisher { get }
    var errorBinding: Published<String?>.Publisher { get }
    var rowToUpdateBinding: Published<Int>.Publisher { get }
    var numberOfItems: Int{ get }
    func getRedditFeeds()
    func getTitle(at row: Int) -> String
    func getCommentNumber(at row: Int) -> String
    func getScore(at row: Int) -> String
    func getImageData(at row: Int) -> Data?
}

class RedditFeedViewModel: RedditFeedViewModelType  {

    private var repository: RedditFeedRepositoryService?
    private var imagesCache = [String: Data]()

    init(repository: RedditFeedRepositoryService = RedditFeedRepository()) {
        self.repository = repository
    }

    var feedBinding: Published<[ChildData]>.Publisher { $redditFeeds }
    var errorBinding: Published<String?>.Publisher { $errorMessage }
    var rowToUpdateBinding: Published<Int>.Publisher { $rowToUpdate }

    var numberOfItems: Int {
        return redditFeeds.count
    }

    // MARK: - private properties
    @Published private var redditFeeds = [ChildData]()
    @Published private var errorMessage:String?
    @Published private var searchResults: [RedditFeedResponse] = []
    @Published private var rowToUpdate = 0
    
    var after: String?

    func getRedditFeeds() {
        repository?.searchFeed(after: self.after, modelType: RedditFeedResponse.self, completionHandler: { result in
            switch result {
            case .success(let response):
                let dataResponse = response.data
                let children = dataResponse.children
                let feeds = children.map { child in
                    return child.data
                }
                self.redditFeeds.append(contentsOf: feeds)
                self.after = dataResponse.after
                print("AAA: After - \(dataResponse.after)")
            case .failure(let error):
                print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
            }
        })
    }
    
    func getTitle(at row: Int) -> String {
        redditFeeds[row].title
        
    }
    
    func getCommentNumber(at row: Int) -> String { "# comment: \(redditFeeds[row].numComments)" }
    
    func getScore(at row: Int) -> String { "score: \(redditFeeds[row].score)" }
    
    func getImageData(at row: Int) -> Data? {
        
        let thumbnail = redditFeeds[row].thumbnail
        
        if let data = imagesCache[thumbnail] {
            return data
        }
        
        // download image
        repository?.getFeedImage(from: thumbnail, completionHandler: { [weak self] result in
            switch result {
            case .success(let data):
                // save image in cache
                self?.imagesCache[thumbnail] = data
                self?.rowToUpdate = row
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
        return nil
    }

}
