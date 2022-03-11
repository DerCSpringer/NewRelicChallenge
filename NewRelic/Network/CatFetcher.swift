//
//  CatFetcher.swift
//  NewRelic
//
//  Created by newrelic on 8/16/20.
//  Copyright © 2020 newrelic. All rights reserved.
//

import Foundation

protocol CatFetchable {
    func loadCats(perPage: Int, page: Int, queue: DispatchQueue, callback: @escaping (CatResult?, Double) -> Void)
}

class CatFetcher: NSObject, CatFetchable {
    
    static let shared = CatFetcher()
    private var urlSession: URLSession?

    private override init() {
        super.init()
        self.urlSession = URLSession(configuration: URLSessionConfiguration.default)
    }

    private func buildCatFactRequest(perPage: Int, page: Int) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "catfact.ninja"
        components.path = "/breeds"
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(perPage)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let url = components.url!
        let request = URLRequest(url: url)
        return request
    }

    /// Fetches the list of CatDetails.
    ///
    /// - Parameters:
    ///   - perPage:  How many results per page
    ///   - page:     The page of the partial results
    ///   - queue:    The `DispatchQueue` on which the `callback` is called. Default is
    ///               `DispatchQueue.main`.
    ///   - callback: `CatResult` is a list of cat breeds or an empty Array in
    ///               case of an error. `Date` is the amount of time taken to
    ///               complete the call
    func loadCats(perPage: Int, page: Int, queue: DispatchQueue = .main, callback: @escaping (CatResult?, Double) -> Void) {
        
        let request = buildCatFactRequest(perPage: perPage, page: page)
        let startOfRequest = Date()
        
        let task = urlSession?.dataTask(with: request) { data, response, err in
            let result: CatResult?
            
            if let data = data, err == nil {
                let decoder = JSONDecoder()
                
                result = (try? decoder.decode(CatResult.self, from: data)) ?? nil
            } else {
                result = nil
            }
            
            queue.async {
                let endOfRequest = Date()
                let timeTakenForRequest = endOfRequest.timeIntervalSince(startOfRequest)
                callback(result,timeTakenForRequest)
            }
        }
        
        task?.resume()
    }

}
