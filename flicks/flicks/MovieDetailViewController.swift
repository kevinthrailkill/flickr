//
//  MovieDetailViewController.swift
//  flicks
//
//  Created by Kevin Thrailkill on 3/31/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    
    var movie : MovieDetail?
    var movieId: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        MovieDBNetworkService.getMovieFromDB(movieID: movieId) {
            retMovie in
            
            if let mov = retMovie {
                self.movie = mov
                print(self.movie!)
                
            }else{
                //error
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
