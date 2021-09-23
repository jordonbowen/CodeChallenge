//
//  BaseRepository.swift
//  CodeChallenge
//
//  Created by Jordon Bowen on 9/22/21.
//

import Foundation

typealias Completion<T:Decodable> =  ((Result<T, NetworkError>) -> Void)
typealias CompletionData =  ((Result<Data, NetworkError>) -> Void)

class BaseRepository {
    var networkManager:Networkable

    init(networkManager:Networkable = NetworkManager()) {
        self.networkManager = networkManager
    }
}


