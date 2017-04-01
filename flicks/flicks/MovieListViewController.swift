//
//  MovieListViewController.swift
//  flicks
//
//  Created by Kevin Thrailkill on 3/30/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit
import AFNetworking
import KRProgressHUD

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var movieListTableView: UITableView!
    
    @IBOutlet weak var errorView: UIView!
    
    var movieFeed : [MovieBasic] = []
    var filteredMovieFeed : [MovieBasic] = []

    var movieDBEndpoint: MovieDBEndpoint!
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        KRProgressHUD.show(progressHUDStyle: .black, message: "Loading...")
        
        MovieDBNetworkService.getMoviesFromDB(endpoint: movieDBEndpoint) {
            feed in
            
            KRProgressHUD.dismiss()
            
            if let movies = feed {
                self.errorView.isHidden = true
                
                self.movieFeed = movies
                self.movieListTableView.reloadData()
            }else{
                //error
                print("error")
                self.errorView.isHidden = false

                
            }
        }
        
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)) , for: .valueChanged)
        // add refresh control to table view
        movieListTableView.insertSubview(refreshControl, at: 0)
        
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor.clear
        searchController.searchBar.backgroundColor = UIColor.clear
        searchController.searchBar.barStyle = .blackTranslucent
        
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField

        textFieldInsideSearchBar?.font = UIFont(name: "Gill Sans", size: 13.0)
        textFieldInsideSearchBar?.textColor = UIColor(red: 0, green: 0.263, blue: 0.337, alpha: 1.0)

        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar
        
    }
    
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        
        
        MovieDBNetworkService.getMoviesFromDB(endpoint: movieDBEndpoint) {
            feed in
            
            if let movies = feed {
                self.movieFeed = movies
                self.movieListTableView.reloadData()
                refreshControl.endRefreshing()
                self.errorView.isHidden = true
                
            }else{
                //error
                print("error")
                refreshControl.endRefreshing()
                self.errorView.isHidden = false
                
            }
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredMovieFeed = movieFeed.filter { movie in
            return movie.title.lowercased().contains(searchText.lowercased())
        }
        
        movieListTableView.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "DetailSegue" {
            
                let detailViewController = segue.destination
                    as! MovieDetailViewController
            
                let indexPath = movieListTableView.indexPath(for: sender as! UITableViewCell)!
            
                if searchController.isActive && searchController.searchBar.text != "" {
                    detailViewController.movieId = filteredMovieFeed[indexPath.row].movieId
                } else {
                    detailViewController.movieId = movieFeed[indexPath.row].movieId
                }

        }
    }
    
}

extension MovieListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredMovieFeed.count
        }
        
        return movieFeed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var movie : MovieBasic
        
        if searchController.isActive && searchController.searchBar.text != "" {
            movie = filteredMovieFeed[indexPath.row]
        } else {
            movie = movieFeed[indexPath.row]
        }
        
        
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell

        movieCell.movieTitle.text = movie.title
        movieCell.overviewLabel.text = movie.overview
        let imageRequest = URLRequest(url: URL(string: "https://image.tmdb.org/t/p/w342\(movie.posterPath)")!)
        
        movieCell.imageView?.setImageWith(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                self.errorView.isHidden = true
                
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
                self.errorView.isHidden = false
        })
        
        return movieCell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated:true)
        
    }
    
}

extension MovieListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}

