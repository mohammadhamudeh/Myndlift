//
//  Services.swift
//  Myndlift
//
//  Created by Mohammad Hamudeh on 03/03/2022.
//

import Foundation
import Alamofire
typealias MoiveImageDownloadCompletionBlock = (_ image: Data?, _ error: NSError?) -> Void


struct MovieNotification{
    
    static let contentAdded = Notification.Name("newContentAdded")
    static let downloadError = Notification.Name("downloadError")
}
class Service{
    static let instance  = Service()
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
//        DispatchQueue.global(qos: .utility).async {
//            let _ = DispatchQueue.global(qos: .userInitiated)
//
//
//        DispatchQueue.concurrentPerform(iterations: numberOfMovies) { _ in
//
//            let url = URL(string: MoivesURL)!
//            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//                let jsonDecoder = JSONDecoder()
//                do{
//
//                    let movieItem = try jsonDecoder.decode(Movie.self, from: data!)
//
//                    NotificationCenter.default.post(name: MovieNotification.contentAdded, object: movieItem)
//                }catch{
//                    print(error.localizedDescription)
//                }
//
//            }
//            task.resume()
//
//        }
//        }
    }
    func updateImage(imageURL :String, withCompletion completion:@escaping MoiveImageDownloadCompletionBlock){
        let requestURL = URL(string:imageURL)!
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            
            do{
                completion(data,nil)
            }catch{
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
    }
}
