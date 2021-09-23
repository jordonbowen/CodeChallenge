//
//  NetworkManager.swift
//  CodeChallenge
//
//  Created by Jordon Bowen on 9/22/21.
//

import Foundation

enum RequestType:String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case parsingFailed(message:String)
    case errorWith(message:String)
    case networkNotAvailalbe
    case malformedURL(message:String)
}


typealias NetworkCompletion =  (Data?, NetworkError?) -> Void

protocol Networkable {
    func run(baseUrl: String,
                 path: String,
                 params:[String:String],
                 requestType:RequestType,
                 completionHandler: @escaping NetworkCompletion)
}


class NetworkManager: Networkable {

    func run(baseUrl: String,
                 path: String,
                 params:[String:String],
                 requestType:RequestType,
                 completionHandler: @escaping NetworkCompletion) {

        guard var urlComponents = URLComponents(string:baseUrl.appending(path)) else {
            completionHandler(nil,.malformedURL(message:""))
            return
        }
        if requestType == .get {
            var queryItems:[URLQueryItem] = []
            for (key , value) in params {
                queryItems.append( URLQueryItem(name: key, value: value))
            }
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            completionHandler(nil, .malformedURL(message:""))
            return
        }
        var request = URLRequest(url: url)

        switch requestType {
        case .get:
            request.httpMethod = RequestType.get.rawValue
        case .post:
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
                request.httpMethod = RequestType.post.rawValue

            }catch {
                completionHandler(nil, .malformedURL(message:""))
                return
            }
        }

        URLSession.shared.dataTask(with:request) {  (data, responce, error)  in
            guard  let _responce = responce as? HTTPURLResponse , _responce.statusCode == 200 else {
                completionHandler(nil, .errorWith(message: ""))
                return
            }

            guard let data = data, error == nil else {
                completionHandler(nil, .errorWith(message:""))
                return
            }

            completionHandler(data, nil)

        }.resume()
    }
}
