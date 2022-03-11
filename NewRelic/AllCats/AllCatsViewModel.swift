//
//  AllCatsViewModel.swift
//  NewRelic
//
//  Copyright © 2022 newrelicchallenge. All rights reserved.
//

import Foundation

enum ConnectionError: Error {
    case noInternetConnection
    case apiRateLimitReached
}

enum DownloadState {
    case downloading
    case done
}

class AllCatsViewModel {

    private var nextPageToDownload = 1
    private let catsPerPage = 25
    private let maxPages = 4
    private var networkResponseTimes = [TimeInterval]()
    private var timeOfNetworkCalls = [Date]()
    private let catFetcher: CatFetchable
    private var allCats = Array([CatDetail(breed: "",
                                          country: "",
                                          origin: "",
                                          coat: "",
                                          pattern: "")])
    private var downloadState: DownloadState = .downloading

    init(catFetcher: CatFetchable) {
        self.catFetcher = catFetcher
    }

    lazy var isAbleToDownloadMoreCats = {
        self.isDownloading() == false &&
        self.hasReachedAPIRateLimit() == false &&
        self.didFetchAllCats() == false
    }

    func getMoreCats(callback: @escaping (Error?) -> ()) {
        timeOfNetworkCalls.append(Date())
        guard hasReachedAPIRateLimit() == false else {
            callback(ConnectionError.apiRateLimitReached)
            return
        }
        guard nextPageToDownload <= maxPages else { return }
        if nextPageToDownload != 1 || allCats.isEmpty {
            allCats.append(CatDetail(breed: "",
                                     country: "",
                                     origin: "",
                                     coat: "",
                                     pattern: ""))
            callback(nil)
        }
        downloadState = .downloading

        let dataCallback = { [weak self] (cats: CatResult?, timeTaken: TimeInterval) in

            guard let self = self else { return }

            let numberOfBlankCatDetailEntries = 1
            self.allCats.removeLast(numberOfBlankCatDetailEntries)
            self.downloadState = .done

            guard let cats = cats else {
                callback(ConnectionError.noInternetConnection)
                return
            }

            self.nextPageToDownload += 1

            self.networkResponseTimes.append(timeTaken)
            self.allCats.append(contentsOf: cats.data)
            callback(nil)
        }

        let queue = DispatchQueue.main

        catFetcher.loadCats(perPage: catsPerPage,
                            page: nextPageToDownload,
                            queue: queue,
                            callback: dataCallback)

    }

    func catForIndexPath(_ indexPath: IndexPath) -> CatDetail? {
        guard indexPath.row < allCats.count else { return nil }
        return allCats[indexPath.row]
    }

    func numberOfCats() -> Int {
        return allCats.count
    }

    func didFetchAllCats() -> Bool {
        nextPageToDownload > maxPages
    }

    func getNetworkResponseTimes() -> [TimeInterval] {
        networkResponseTimes
    }

}

private extension AllCatsViewModel {

    func hasReachedAPIRateLimit() -> Bool {
        let maxAPICalls = 7
        let periodOverWhichMaxAPICallsAllowedInSeconds = 60.0
        let attemptsInTheLastMinute = self.timeOfNetworkCalls.filter {
            Date().timeIntervalSince($0) <= periodOverWhichMaxAPICallsAllowedInSeconds
        }
        self.timeOfNetworkCalls = attemptsInTheLastMinute
        return attemptsInTheLastMinute.count >= maxAPICalls ? true : false
    }
    
    func isDownloading() -> Bool {
        downloadState == .downloading ? true : false
    }
}
