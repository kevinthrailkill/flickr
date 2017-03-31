//
//  NowPlayingViewController.swift
//  flicks
//
//  Created by Kevin Thrailkill on 3/30/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit
import Alamofire

class NowPlayingViewController: UIViewController {
    
    @IBOutlet weak var nowPlayingTableView: UITableView!
    
    var movieFeed : [MovieBasic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MovieDBNetworkService.getMoviesFromDB(endpoint: .nowPlaying) {
            feed in
            
            if let movies = feed {
                self.movieFeed = movies
                self.nowPlayingTableView.reloadData()
            }else{
                //error
            }
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)) , for: .valueChanged)
        // add refresh control to table view
        nowPlayingTableView.insertSubview(refreshControl, at: 0)
        
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        MovieDBNetworkService.getMoviesFromDB(endpoint: .nowPlaying) {
            feed in
            
            if let movies = feed {
                self.movieFeed = movies
                self.nowPlayingTableView.reloadData()
                refreshControl.endRefreshing()
            }else{
                //error
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension NowPlayingViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieFeed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = movieFeed[indexPath.row]
        
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "NowPlayingCell", for: indexPath) as! MovieCell

        movieCell.movieTitle.text = movie.title
        movieCell.movieInfoText.text = movie.overview
        let imageRequest = URLRequest(url: URL(string: "https://image.tmdb.org/t/p/w342\(movie.posterPath)")!)
        
        movieCell.imageView?.setImageWith(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    movieCell.imageView?.alpha = 0.0
                    movieCell.imageView?.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        movieCell.imageView?.alpha = 1.0
                    })
                } else {
                    movieCell.imageView?.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
        
        return movieCell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated:true)
        
    }
    
}

