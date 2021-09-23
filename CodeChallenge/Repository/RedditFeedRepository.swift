//
//  RedditFileRepository.swift
//  CodeChallenge
//
//  Created by Jordon Bowen on 9/22/21.
//

import Foundation

protocol RedditFeedRepositoryService {
    func searchFeed<T:Decodable>(after: String?, modelType:T.Type, completionHandler:@escaping Completion<T> )
    func getFeedImage(from thumbnail: String, completionHandler:@escaping CompletionData)
}


class RedditFeedRepository: BaseRepository, RedditFeedRepositoryService, DecodeJson {
    
    func getFeedImage(from thumbnail: String, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        networkManager.run(baseUrl: thumbnail, path: "", params: [:], requestType: RequestType.get) { data, error in
            guard let data = data, error == nil else {
                completionHandler(.failure(.errorWith(message: error!.localizedDescription)))
                return
            }
            // Parsing data using JsonDecoder
            completionHandler(.success(data))
        }
    }
    
    func searchFeed<T>(after: String?, modelType: T.Type, completionHandler: @escaping Completion<T>) where T : Decodable {
        networkManager.run(baseUrl: EndPoint.baseUrl + (after ?? ""), path:"", params: [:], requestType:RequestType.get) {[weak self] data, error in

            guard let data = data, error == nil else {
                completionHandler(.failure(.errorWith(message: error!.localizedDescription)))
                return
            }
            // Parsing data using JsonDecoder

            if let result = self?.decodeObject(input:data, type:modelType.self) {
                completionHandler(.success(result))
            }else {
                completionHandler(.failure(.parsingFailed(message:"")))
            }
        }
    }
}
