//
//  CatList.swift
//  NewRelic
//
//  Created by newrelic on 8/16/20.
//  Copyright © 2020 newrelic. All rights reserved.
//

import Foundation

struct CatDetail: Codable, Equatable {
    var breed: String
    var country: String
    var origin: String
    var coat: String
    var pattern: String
}

struct CatResult: Codable {
    var data: [CatDetail]
    var current_page: Int
    var total: Int
}
