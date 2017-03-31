//
//  TopRatedViewController.swift
//  flicks
//
//  Created by Kevin Thrailkill on 3/30/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit
import AFNetworking
import KRProgressHUD

class TopRatedViewController: UIViewController {

    @IBOutlet weak var topRatedTableView: UITableView!
    var movieFeed : [MovieBasic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KRProgressHUD.show(progressHUDStyle: .black, message: "Loading...")
        
        MovieDBNetworkService.getMoviesFromDB(endpoint: .topRated) {
            feed in
            
            KRProgressHUD.dismiss()
            
            if let movies = feed {
                self.movieFeed = movies
                self.topRatedTableView.reloadData()
            }else{
                //error
            }
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)) , for: .valueChanged)
        topRatedTableView.insertSubview(refreshControl, at: 0)
        
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        MovieDBNetworkService.getMoviesFromDB(endpoint: .topRated) {
            feed in
            
            if let movies = feed {
                self.movieFeed = movies
                self.topRatedTableView.reloadData()
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "DetailSegueTopRated" {
            
            let detailViewController = segue.destination
                as! MovieDetailViewController
            
            let indexPath = topRatedTableView.indexPath(for: sender as! UITableViewCell)!
            let movieID = movieFeed[indexPath.row].movieId
            detailViewController.movieId = movieID
        }
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


