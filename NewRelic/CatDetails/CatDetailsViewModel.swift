//
//  CatDetailsViewModel.swift
//  NewRelic
//
//  Copyright © 2022 newrelicchallenge. All rights reserved.
//

import Foundation

struct CatDetailsViewModel {

    private let catDetail: CatDetail

    init(catDetail: CatDetail) {
        self.catDetail = catDetail
    }

    lazy var breed: String = {
        catDetail.breed
    }()

    lazy var country: String = {
        catDetail.country
    }()

    lazy var origin: String = {
        catDetail.origin
    }()

    lazy var coat: String = {
        catDetail.coat
    }()

    lazy var pattern: String = {
        catDetail.pattern
    }()

}
