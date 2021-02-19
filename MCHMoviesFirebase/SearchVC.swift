//
//  SearchVC.swift
//  MCHMoviesFirebase
//
//  Created by Karen Mathes on 2/18/21.
//  Copyright © 2021 TygerMatrix Software. All rights reserved.
//

import UIKit

//.. Search the API to get a list of movies matching the search criteria entered
class SearchVC: UIViewController {

    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    
    //.. array used for movie API info coming back
    var movieArrayTup: [(xName: String, xYear: String, xType: String, xIMDB: String, xPoster: String)] = [("","","","","")]
    
    var searchText = ""
    
    //..
    //  http://www.omdbapi.com?apikey=1b6ca2da&s=contact //Where and how to hide apikey?
    let apiKey = "1b6ca2da"

    //.. Movie JSON example from API
    //{"Search":[{"Title":"Contact","Year":"1997","imdbID":"tt0118884","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BYWNkYmFiZjUtYmI3Ni00NzIwLTkxZjktN2ZkMjdhMzlkMDc3XkEyXkFqcGdeQXVyNDk3NzU2MTQ@._V1_SX300.jpg"},{"Title":"Star Trek: First Contact","Year":"1996","imdbID":"tt0117731","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BYTllZjRkY2QtYTJlMy00ZTMxLWE0YWQtMWMwYzY2YTM3YzRjXkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_SX300.jpg"},{"Title":"Full Contact","Year":"1992","imdbID":"tt0105851","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BMTczNDUwOTU3M15BMl5BanBnXkFtZTgwNTY3NTkwMzE@._V1_SX300.jpg"},

    struct Search: Codable {
        
        let title: String
        let year: String
        let imdbID: String
        let type: String
        let posterUrl: String
        
        private enum CodingKeys: String, CodingKey {
            case title = "Title"        //..map JSON "Title" to new name title
            case year = "Year"          //..map JSON "Year" to new name year
            case imdbID                 //..JSON name is imdbID; so, no change
            case type = "Type"          //..map JSON "Type" to new name type
            case posterUrl = "Poster"   //..map JSON "Poster" to new name poster
        }
    }

    struct Movie: Codable {
        
        let search: [Search]    //..maps to Search Structure above
        
        private enum CodingKeys: String, CodingKey {
            case search = "Search"       //..map JSON "Search" to new name search
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    //        The first line defines the view as an observer to receive the keyboardWillShowNotification. When this notification appears, then the app needs to run a function called keyboardWillShow. The second line defines the view as an observer to receive the keyboardWillHideNotification. When this notification appears, then the app needs to run a function called keyboardWillHide.
            
            NotificationCenter.default.addObserver( self , selector: #selector (keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil )
            
            NotificationCenter.default.addObserver( self , selector: #selector (keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil )
            
    //        This code allows the view to detect tap gestures (when the user taps outside of a text field). When this occurs, this line runs a function called dismissKeyboard .
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self , action: #selector (self.dismissKeyboard))
            view.addGestureRecognizer(tap)
            
//            searchTextField.placeholder = "Email address here"
//            searchTextField.textColor = UIColor.red
//            searchTextField.font = UIFont(name: "Courier", size: 16)
//            //.. gets rid of the little "clear" x in the right side corner of the text box
//            searchTextField.clearButtonMode = .whileEditing
                
    }
    
    //    This function runs when the user taps outside of a text field, which ends editing and sends the notification that the virtual keyboard needs to go away (keyboardWillHideNotification).
       
        @objc func dismissKeyboard() {
            view.endEditing( true )
        }
        
    //    This function defines the keyboard size based on the size of the iOS screen. (Remember, iPhone screens are narrower than iPad screens.) Then this function uses the height of the virtual keyboard to determine how far to slide the view (along with all its user interface objects) up to make room for the virtual keyboard.

        @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
               }
            }
        }
        
    //    This function checks if the virtual keyboard is visible. If not, then do nothing. If the virtual keyboard is visible, then move the view back down to cover and hide the virtual keyboard

        @objc func keyboardWillHide(notification: NSNotification) {
            if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y = 0
                }
            }
        }

       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let vc = segue.destination as! MovieListVC
            
        vc.finalName = self.searchText
       
        //.. if the movie names aren't equal, sort on the names asc... if they are equal, sort on the year desc
        let movieArrayTupSorted = movieArrayTup.sorted { $0.0 != $1.0 ? $0.0 < $1.0 : $0.1 > $1.1 }
       
        vc.movieArrayTupSorted2 = movieArrayTupSorted
        //.. you can also call a func instead (ie. vc.kamSetArray(movieArray8) for example
            
    }

    @IBAction func searchMovieButtonPressed(_ sender:  UIButton) {
                
        self.searchText = searchTextField.text ?? ""
        var _ = queryJSON(query: searchText )
    }
    
    //.. to query movie api
    func queryJSON(query: String) {
      
       self.movieArrayTup.removeAll()
        
        //..build the url for going out to movie api to get JSON data
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.omdbapi.com"
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "s", value: query)//,
        ]
        
        let url = components.url
        //.. another good example to play around with
        //let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        //***********************************************************************************************************
        //.. from https://stackoverflow.com/questions/48130993/swift-4-jsonserialization-jsonobject
        //..
        //let task = URLSession.shared.dataTask(with: url.getURL()) { data, _, error in
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            
            //.. prints url data - useful to see movie api string built
//            let myResponse = response
//            print("\nMy Url Response = \(String(describing: myResponse))")
            
            var h = 0
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(Movie.self, from: data)
                
                for item in responseObject.search {
                    
                    let t = item.title
                    let y = item.year
                    let typ = item.type
                    let p = item.posterUrl
                    let i = item.imdbID
               
                    self.movieArrayTup.append((xName: t, xYear: y, xType: typ, xIMDB: i, xPoster: p))
                    
                    h += 1
                }
                
            } catch {
                print("Uh oh, that didn't work :(")
                print(error)
            }
            
            // if you then need to update UI or model objects, dispatch that back
            // to the main queue:
            DispatchQueue.main.async {
                // use `responseObject.data` to update model objects and/or UI here
                
                print("\nIn DispatchQueue -> .....)\n")
                self.searchTextField.text = ""
                self.performSegue(withIdentifier: "moviesSegue", sender: self)
            }
            
            
        } //.. end of closure
        
        task.resume()
        
    }

        
}

