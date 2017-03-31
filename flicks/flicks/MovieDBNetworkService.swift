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
    
    

    
    class func getNowPlaying(completion: @escaping ([MovieBasic]?) -> ()) {
        let apiKey = "59dca7909ec71fbb24062d5ac0b5554c"
        
        Alamofire.request("https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)").responseArray(queue: DispatchQueue.main, keyPath: "results", options: JSONSerialization.ReadingOptions.allowFragments) { (response: DataResponse<[MovieBasic]>) in
            
            let movies = response.result.value
            completion(movies)
            
        }
    }
    
    class func getTopRated(completion: @escaping ([MovieBasic]?) -> ()) {
        let apiKey = "59dca7909ec71fbb24062d5ac0b5554c"
        
        Alamofire.request("https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)").responseArray(queue: DispatchQueue.main, keyPath: "results", options: JSONSerialization.ReadingOptions.allowFragments) { (response: DataResponse<[MovieBasic]>) in
            
            let movies = response.result.value
            completion(movies)
            
        }
    }
    
    
}



