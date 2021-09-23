//
//  MockRepository.swift
//  CodeChallengeTests
//
//  Created by Jordon Bowen on 9/22/21.
//

import Foundation
@testable import CodeChallenge

class MockRepository: BaseRepository, RedditFeedRepositoryService {
    
    func searchFeed<T>(after: String?, modelType: T.Type, completionHandler: @escaping Completion<T>) where T : Decodable {
        
        print("This should be fired")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            // if nil, force failure
            if after == nil {
                completionHandler(.failure(NetworkError.errorWith(message: "Mock Forced Error")))
            }
            
            // Otherwise success
            if let path = Bundle(for: CodeChallengeTests.self).path(forResource: "Sample", ofType: "json") {
                let url = URL(fileURLWithPath: path)
                
                do {
                    let data = try Data(contentsOf: url)
                    let model = try JSONDecoder().decode(modelType, from: data)
                    completionHandler(.success(model))
                } catch {
                    completionHandler(.failure(NetworkError.parsingFailed(message: error.localizedDescription)))
                }
                
            } else {
                completionHandler(.failure(NetworkError.errorWith(message: "Mock Forced Error")))
            }
        })
        
    }
    
    func getFeedImage(from thumbnail: String, completionHandler: @escaping CompletionData) {
        // Come back to this if needed
    }
    
}
