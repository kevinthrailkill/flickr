//
//  MovieDetailViewController.swift
//  flicks
//
//  Created by Kevin Thrailkill on 3/31/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit
import KRProgressHUD

class MovieDetailViewController: UIViewController {

    
    var movie : MovieDetail?
    var movieId: Int!
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var detailSlideUp: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorView.isHidden = true
        KRProgressHUD.show(progressHUDStyle: .black, message: "Loading...")
        
        MovieDBNetworkService.getMovieFromDB(movieID: movieId) {
            retMovie in
            
            KRProgressHUD.dismiss()
            
            if let mov = retMovie {
                self.errorView.isHidden = true
                self.movie = mov
                print(self.movie!)
                self.updateUI()
                
            }else{
                //error
                self.errorView.isHidden = false
                print("error")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI(){
        
        getImageForBackground()
        setLabels()
        detailSlideUp.sizeToFit()
        detailSlideUp.layer.cornerRadius = 10

    }
    
    func setLabels() {
        movieTitleLabel.text = movie!.title
        releaseDateLabel.text = movie!.releaseDate
        popularityLabel.text = movie!.popularity.description
        timeLabel.text = movie!.runTime.description
        overviewLabel.text = movie!.overview
        overviewLabel.sizeToFit()
        
    }
    
    func getImageForBackground(){
        

        let smallImageRequest = URLRequest(url: URL(string: "https://image.tmdb.org/t/p/w45\(movie!.posterPath)")!)
        let largeImageRequest = URLRequest(url: URL(string: "https://image.tmdb.org/t/p/original\(movie!.posterPath)")!)

        
        
        moviePosterImageView.setImageWith(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                self.moviePosterImageView.alpha = 0.0
                self.moviePosterImageView.image = smallImage
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    
                    self.moviePosterImageView.alpha = 1.0
                    
                }, completion: { (sucess) -> Void in
                    
                    // The AFNetworking ImageView Category only allows one request to be sent at a time
                    // per ImageView. This code must be in the completion block.
                    self.moviePosterImageView.setImageWith(
                        largeImageRequest,
                        placeholderImage: smallImage,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            self.moviePosterImageView.image = largeImage;
                            
                    },
                        failure: { (request, response, error) -> Void in
                            // do something for the failure condition of the large image request
                            // possibly setting the ImageView's image to a default image
                    })
                })
                
                
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
    }

}
