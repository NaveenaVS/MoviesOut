//
//  MoviesViewController.swift
//  Flixup
//
//  Created by Naveena vishnu on 9/22/20.
//  Copyright © 2020 vishnaveena. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    //creating outlets:
    @IBOutlet weak var tableView: UITableView!
    
    
    //this variable here is what we call property which will be available for the entirety of the screen run
    var movies = [[String: Any]]() //creating an array of dictionary of key type String and value type Any
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //need to include the below to statements so that the two functions created below runs:
           tableView.dataSource = self
           tableView.delegate = self
        
        // this is the function that runs as soon as i launch the screen associated with this swift file:
        //we are gonna run a network request that uses api to fetch data of the latest movies in the theatre:
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            //The dataDictionary variable is where we get the fetched data info -> dataDictionary is the thing that has the data
            
            //now i wanna print my fetched data in the form of json list:
            //print(dataDictionary) //ur movie the info from web into ur application.

            //calling the result of the api we called earlier using the movies variable created above:
            //So essentially I wanna say, hey movies I want u to look in that dataDictionary and I want u to get out "results" -> this is how i access I access a particular key inside a dictionary
            
            self.movies = dataDictionary["results"] as! [[String: Any]] //here we do two things: cast fix with the (self.) and closure fix (with the self.)
            
            //to reload the data:
            self.tableView.reloadData()
            
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

            }
        }
        task.resume()
    }
    
    //funtions to help use the table view:
    //this function is asking for the no. of rows -> we return movies.count //no. of moviewa
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
      }
      
    //saying gimme the cell for this (cellForRowAt) particular row.
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating a new cell and then return that cell. in between we configure it
        //let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell //tyoe cast to be able to access it like a movie cell
        
       // cell.textLabel!.text = "row: \(indexPath.row)" //to insert values in between Strings use:"String stuff \(variable_name)"
        //indexPath.row is gonna change and this function gets called 50 times
        
        //wanna print out movie title instead of just the rows: movies is the array of dcitionaries we created earlier
        let movie = movies[indexPath.row]
        //want to have the title of the movie: go to api and find what the appropriate key is for the movie title
        let title = movie["title"] as! String //casting cus u want ur printed title to be a string
        
        //want to extract movie synopsis:
        let synopsis = movie["overview"] as! String
        
        //cell.textLabel!.text = title
        //we use the outlet we created to get the movie title on our custom cells:
        cell.titleLabel.text = title
        //acess the other outlet to configure synopsis text:
        cell.synopsisLabel.text = synopsis //only this when run will give one synopsis line that it extracted. to get more we configure the no. of lines in the main.storybard for the label-> 0 lines => it will grow to as many lines as u have content.
        
        //setting up the poster details for viewing the image:
        let baseUrl = "https://image.tmdb.org/t/p/w185" //add this base url to ur poster
        let posterPath = movie["poster_path"] as! String
        //need to combine baseurl with path:
        let posterUrl = URL(string: baseUrl+posterPath)
        
        //now i have the url but this needs to downloaded the img into my poster on the app: so here is where we use cocoapods!!
        //new function that can be applied cus we imported the AlamofireImage library
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        
        return cell
      }
      

    //this function is used to prepare next screen whe leaving ur screen -> data sending
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        //need this funct to do 2 tasks:
        //a. find the selected movie
        let cell = sender as! UITableViewCell //this is the cell tapped on
        //ask table view what the indexpath is:
        let indexPath = tableView.indexPath(for: cell)! // index path of the cell that was tapped on
        let movie = movies[indexPath.row] //accessing the array
        //now we need to store the movie we tapped on into the details view controller
        
        //b. pass the selected movie to the details viewController
        let detailsViewContoller = segue.destination as! MovieDetailsViewController //casting to whatver thing exists after the "as !"
        detailsViewContoller.movie = movie
        
        //to remove the selected highlight when we go back to the movies tab we need to manually deselect it:
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
   

}
