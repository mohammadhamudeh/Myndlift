//
//  MoveSuggestionViewController.swift
//  Myndlift
//
//  Created by Mohammad Hamudeh on 03/03/2022.
//

import UIKit

class MovieSuggestionViewController: UIViewController {
    @IBOutlet weak var addNewMoviesCollectionBtn: UIButton!
    var numberOfMovies = 0
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stepperAdd: UIStepper!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var newMovieAdditionView: UIView!
    @IBOutlet weak var moviesTableView: UITableView!
    let movieCellId = "movieItemCell"
    var movies : [Movie] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.stopAnimating()
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(contentChangedNotification(_:)),
          name: MovieNotification.contentAdded,
          object: nil)

        
        
    }
    
    @IBAction func stepperChange(_ sender: UIStepper) {
        numberLabel.text = "\(Int(sender.value))"
    }
    func removeData(){
        self.movies.removeAll()
        self.moviesTableView.reloadData()
    }
    @IBAction func addMoviesBtnPressed(_ sender: Any) {
        removeData()
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        
        addNewMoviesCollectionBtn.isEnabled = false
        
        numberOfMovies = Int(stepperAdd.value)
        DispatchQueue.global(qos: .userInteractive).async {
            Service.instance.getMoives(numberOfMovies:self.numberOfMovies )
        }
//        DispatchQueue(label: "downloadMovies").async{
//           
//        }
        
        
    }
    
    @IBAction func clearData(_ sender: UIBarButtonItem) {
       removeData()
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
    
}
