//
//  Movie.swift
//  flicks
//
//  Created by Kevin Thrailkill on 3/30/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import Foundation
import Unbox

struct MovieBasic : Unboxable {
    
    let movieId: Int
    let title: String
    let posterPath: String?
    let overview: String
    
    init(unboxer: Unboxer) throws {
        self.movieId = try unboxer.unbox(key: "id")
        self.title = try unboxer.unbox(key: "title")
        self.posterPath = unboxer.unbox(key: "poster_path")
        self.overview = try unboxer.unbox(key: "overview")
    }
    

}

struct MovieDetail : Unboxable {
    
    let movieId: Int
    let title: String
    let posterPath: String?
    let overview: String
    let releaseDate: String
    let runTime: Int
    let popularity: Double
    
    init(unboxer: Unboxer) throws {
        self.movieId = try unboxer.unbox(key: "id")
        self.title = try unboxer.unbox(key: "title")
        self.posterPath = unboxer.unbox(key: "poster_path")
        self.overview = try unboxer.unbox(key: "overview")
        self.releaseDate = try unboxer.unbox(key: "release_date")
        self.runTime = try unboxer.unbox(key: "runtime")
        self.popularity = try unboxer.unbox(key: "popularity")
        
    }
}
