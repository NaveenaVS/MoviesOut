//
//  MovieDetailsViewController.swift
//  Flixup
//
//  Created by Naveena vishnu on 9/28/20.
//  Copyright © 2020 vishnaveena. All rights reserved.
//

import UIKit
import AlamofireImage //library that helps us download image from the internet

class MovieDetailsViewController: UIViewController {

    
    @IBOutlet weak var backDropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    
    @IBOutlet weak var gradientView: UIImageView!//i added :)
    
    
    //type dictionary:
    var movie : [String: Any]! //why do we have colon instead of = , cus we are passing the whole movie dictionery here not creating a new one - so now here we can configure the view we're gonna set.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //testing: when movie is tapped in simulator the title of that movie should appear in the console cus of the following print statement:
        //print(movie["title"])
        
        titleLabel.text =  movie["title"] as? String //title is what the api calls the title of the moview
        //havent figured auto layout yet so we do:
        titleLabel.sizeToFit()
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        
        // two images to set: potser view and backdrop view:
        //for cells i built up the url from baseurl extracting img from net so we use that here:
        //a setting the poster view:
        let baseUrl = "https://image.tmdb.org/t/p/w185" //retrieved from the documentation
        let posterPath = movie["poster_path"] as! String
        //need to combine baseurl with path:
        let posterUrl = URL(string: baseUrl+posterPath)
        //supports posterview directly so no need cell.posterView
        posterView.af_setImage(withURL: posterUrl!)
        
        //b. setting the backdrop view: its called the backdrop path:
        let backdropPath = movie["backdrop_path"] as! String
        //need to combine baseurl with path:
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath) //updating pixels in url, because the backdrop image is larger and the resolution is poor...780 is the width available for backdrop img. resolution resolved!

        backDropView.af_setImage(withURL: backdropUrl!)
        
        //making gradient:
        let gradientUrl = URL(string: "https://i.imgur.com/KcGCJyn.png")
        gradientView.af_setImage(withURL: gradientUrl!) //SUCCESS!
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
