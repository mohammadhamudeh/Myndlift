//
//  Services.swift
//  Myndlift
//
//  Created by Mohammad Hamudeh on 03/03/2022.
//

import Foundation
import Alamofire

struct MovieNotification{
    static let contentAdded = Notification.Name("newContentAdded")
    static let downloadError = Notification.Name("downloadError")
}
class Service{
    
    static let instance  = Service()
    
    /// This function is used for http request it take an integer and repeat request based on that number, in this function we use Alamofire to make http request, each time it raise notification for each object downloaded and parsed to update UI
    /// - Parameter numberOfMovies: int value used to repeat request based on user value hwich is mean if user want 3 movies this value will be 3
    func getMoives(numberOfMovies:Int){
        DispatchQueue.concurrentPerform(iterations: numberOfMovies) { _ in
            AF.request(MoivesURL, method: .get).responseData { data in
                switch data.result{
                case .success(let response):
                    let jsonDecoder = JSONDecoder()
                    do{
                        
                        let movieItem = try jsonDecoder.decode(Movie.self, from: response)
                        
                        NotificationCenter.default.post(name: MovieNotification.contentAdded, object: movieItem)
                    }catch{
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    NotificationCenter.default.post(name: MovieNotification.downloadError, object: error.localizedDescription)
                    break
                }
            }
        }
    }
    
}
