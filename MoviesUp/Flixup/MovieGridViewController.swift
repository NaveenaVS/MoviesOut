//
//  MovieGridViewController.swift
//  Flixup
//
//  Created by Naveena vishnu on 10/1/20.
//  Copyright © 2020 vishnaveena. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    //cretaing outlet for the collection view:
    @IBOutlet weak var collectionView: UICollectionView!
    
    //creating the property movies just like how we did for the moviesviewcontroller but this is for this screen and isnt related to the other one.
     var movies = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mandatory for the below two funtions to work:
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //wanna configure the grid layout and make the spacing look better:
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout //set the layout; next we are gonna configure it
        
        //to control line spacing in between the rows:
        layout.minimumLineSpacing = 4 //spacing od=f 40 pixels between the rows in the grod
        layout.minimumInteritemSpacing = 4
        //but the above two are not dynamic: let us make calculations manually and make the grids looke better:
        
        //access width of phone: so that width changes depending on the phone used:
        //manually doing math to figure out what size u wnat ur grid size to be
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2)/3 // divi by 3 uf u want 3 pics in a row .... the math behind subbing with layout and then multiplying that with 2 is because we multiply with n-1; here n=3 so n-1=2 --> math stuff :(
        layout.itemSize = CGSize(width: width, height: width * 1.5) //making ht funct of width but 1.5 times more cus want it to be taller
        
        //making network request for similar movies to onward which is a cartoon: url changed
        let url = URL(string: "https://api.themoviedb.org/3/movie/508439/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
           
            
            self.movies = dataDictionary["results"] as! [[String: Any]]
            
            //the following needs to be added so that this function is repeatedly called to get the data: i.e calls the bottom two functions of collection view
            self.collectionView.reloadData()
            //here we create the collection view because we want the movies to be displayed in grids.
            //checking:
            //print(self.movies)//will give all the movies related to mulan

            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           //doing our customizations below:
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell //casting
        //after the above setup -> refer back to the moviesViewController and try to create the equivalent funtions
        
        //copy pasting from the moviesviewcontroller: we want the poster view image for each cell in the grid we are creating
        //cretaing movie var to get info from the array of dict
        let movie = movies[indexPath.item] //unlike table view, we dont have rows but instead we have items here
        //import the pod-> almofireimage to get the images set up
        
        //setting up the poster details for viewing the image:
            let baseUrl = "https://image.tmdb.org/t/p/w780" //add this base url to ur poster; changed the res to w780
            let posterPath = movie["poster_path"] as! String
            //need to combine baseurl with path:
            let posterUrl = URL(string: baseUrl+posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
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
