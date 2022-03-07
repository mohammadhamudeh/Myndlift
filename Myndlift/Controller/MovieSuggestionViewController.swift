//
//  MoveSuggestionViewController.swift
//  Myndlift
//
//  Created by Mohammad Hamudeh on 03/03/2022.
//

import UIKit

class MovieSuggestionViewController: UIViewController {
    
    /// Outlets
    @IBOutlet weak var addNewMoviesCollectionBtn: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stepperAdd: UIStepper!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var newMovieAdditionView: UIView!
    @IBOutlet weak var moviesTableView: UITableView!
    
    ///variables
    ///this is represents cell id added on storyboard
    let movieCellId = "movieItemCell"
    
    /// array to store retrived movies
    var movies : [Movie] = []
    
    /// assign stepper value to it
    var numberOfMovies = 0
    
    
    /// configure notification settings
    /// configure activity indicator initial settings
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.stopAnimating()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentChangedNotification(_:)),
            name: MovieNotification.contentAdded,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadDataErrorNotification(_:)),
            name: MovieNotification.downloadError,
            object: nil)
        
        
    }
    
    /// used to handle change in stepper value
    /// - Parameter sender: stepper
    @IBAction func stepperChange(_ sender: UIStepper) {
        numberLabel.text = "\(Int(sender.value))"
    }
    
    /// remove all array elements and delete all cells from table view
    func removeData(){
        self.movies.removeAll()
        self.moviesTableView.reloadData()
    }
    
    /// handle add button movies take stepper value and send it to getmovies function as parameter to retrive moives based on user choose
    
    @IBAction func addMoviesBtnPressed(_ sender: Any) {
        removeData()
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        
        addNewMoviesCollectionBtn.isEnabled = false
        
        numberOfMovies = Int(stepperAdd.value)
       
            Service.instance.getMoives(numberOfMovies:self.numberOfMovies )
        
    }
    
    /// this function is used to clean all data, calls remove data function
    /// - Parameter sender: <#sender description#>
    @IBAction func clearData(_ sender: UIBarButtonItem) {
        removeData()
    }
    
   
    
}
extension MovieSuggestionViewController:UITableViewDataSource{
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: movieCellId, for: indexPath) as? MovieTableViewCell{
            cell.updateCell(moive: movies[indexPath.row])
            return cell
        }
        return MovieTableViewCell()
    }
    
}

extension MovieSuggestionViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: movies[indexPath.row].getDescriptionURL()) {
            UIApplication.shared.open(url)
        }
    }
}

extension MovieSuggestionViewController{
    
    /// used to handle notification function and parse add data to movies array  then update table
    
    @objc func contentChangedNotification(_ notification: Notification!) {
        
        
        DispatchQueue.main.async {
            self.movies.append((notification.object as? Movie)!)
            
            self.moviesTableView.insertRows(at: [IndexPath(row: self.movies.count - 1, section: 0)], with: .automatic)
            if self.numberOfMovies == self.movies.count{
                self.loadingIndicator.stopAnimating()
                self.addNewMoviesCollectionBtn.isEnabled = true
            }
        }
        
    }
    
    /// this function is ued to handle if there is any error whe retriving any movie rasied by notifiation from http request
    
    @objc func loadDataErrorNotification(_ notification: Notification!) {
        let alert = UIAlertController(title: "Download Error", message: "WE are having some issues with retriving content.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
               
            }
        }))
        DispatchQueue.main.async {
            if (self.presentedViewController == nil){
            self.present(alert, animated: true) {
                self.addNewMoviesCollectionBtn.isEnabled = true
                self.loadingIndicator.stopAnimating()
            }
                
            }
        }
        
    }
    
    
}
