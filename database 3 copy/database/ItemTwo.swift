//
//  ItemTwo.swift
//  database
//
//  Created by Jacob Parker on 11/25/18.
//  Copyright © 2018 Santa Clara University. All rights reserved.
//

import Foundation
import RealmSwift

class movie_data: Object {
    @objc dynamic var title: String? = nil
    @objc dynamic var imdbID: String? = nil
    @objc dynamic var criticName: String? = nil
    @objc dynamic var criticReview: String? = nil
    let rating = RealmOptional<Int>()
    let date = RealmOptional<Int>()
    @objc dynamic var genre: String? = nil
    @objc dynamic var poster: String? = nil
    
//    convenience init(prior_data: movie_reviews, title: String, genre: String, poster: String) {
//        self.init()
//        self.title = prior_data.title
//        self.imdbID = prior_data.imdbID
//        self.criticName = prior_data.criticName
//        self.criticReview = prior_data.criticReview
//        self.rating = prior_data.rating!
//        self.date = prior_data.date!
//        self.title = title
//        self.genre = genre
//        self.poster = poster
//    }
}
