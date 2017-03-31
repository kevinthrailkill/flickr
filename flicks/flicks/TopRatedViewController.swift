//
//  TopRatedViewController.swift
//  flicks
//
//  Created by Kevin Thrailkill on 3/30/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit

class TopRatedViewController: UIViewController {

    @IBOutlet weak var topRatedTableView: UITableView!
    var movieFeed : [MovieBasic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MovieDBNetworkService.getTopRated() {
            feed in
            
            if let movies = feed {
                self.movieFeed = movies
                self.topRatedTableView.reloadData()
            }else{
                //error
            }
            
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension TopRatedViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieFeed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = movieFeed[indexPath.row]
        
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "TopRatedCell", for: indexPath) as! MovieCell
        
        
        movieCell.movieTitle.text = movie.title
        movieCell.movieInfoText.text = movie.overview
        
        
        let url = URL(string: "https://image.tmdb.org/t/p/w342\(movie.posterPath)")!
        
        movieCell.imageView?.af_setImage(withURL: url)
        
        
        return movieCell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated:true)
        
    }

}

