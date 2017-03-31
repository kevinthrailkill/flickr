//
//  MovieDBNetworkService.swift
//  flicks
//
//  Created by Kevin Thrailkill on 3/30/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import Foundation
import Alamofire
import Unbox
import UnboxedAlamofire


class MovieDBNetworkService {
    
    class func getMoviesFromDB(endpoint: MovieDBEndpoint, completion: @escaping ([MovieBasic]?) -> ()) {
        
        let apiKey = "59dca7909ec71fbb24062d5ac0b5554c"
        var whichEndpoint = ""
        
        switch endpoint {
        case .topRated:
            whichEndpoint = "top_rated"
        case .nowPlaying:
            whichEndpoint = "now_playing"
        }
        
        Alamofire.request("https://api.themoviedb.org/3/movie/\(whichEndpoint)?api_key=\(apiKey)&language=en-US").responseArray(queue: DispatchQueue.main, keyPath: "results", options: JSONSerialization.ReadingOptions.allowFragments) { (response: DataResponse<[MovieBasic]>) in
            
            let movies = response.result.value
            completion(movies)
            
        }
    }
    
    class func getMovieFromDB(movieID: Int, completion: @escaping (MovieDetail?) -> ()) {
        
        let apiKey = "59dca7909ec71fbb24062d5ac0b5554c"
        
        Alamofire.request("https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)&language=en-US").responseObject { (response: DataResponse<MovieDetail>) in
            let movie = response.result.value
            
            completion(movie)
            
        }
        
    }
    
}


/// Enum for deciding what endpoint I should hit in the movies db call
///
/// - topRated:
/// - NowPlaying:
enum MovieDBEndpoint {
    case topRated
    case nowPlaying
}
