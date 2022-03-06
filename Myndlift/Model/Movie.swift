//
//  Movie.swift
//  Myndlift
//
//  Created by Mohammad Hamudeh on 03/03/2022.
//

import Foundation
import UIKit
struct Movie:Codable{
    var id:String?
    var slug:String?
    var title:String?
    var overview:String?
    var rating:Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case slug = "slug"
        case title = "title"
        case overview = "overview"
        case rating = "imdb_rating"
        
    }
  
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.slug = try container.decode(String.self, forKey: .slug)
        self.title = try  container.decode(String.self, forKey: .title)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.rating = try container.decode(Double.self, forKey: .rating)
       
    }
   
    func getImageURL()->URL?{
        return URL(string:"\(BaseURL)\(id ?? "")\(posterURL)")
    }
    func getDescriptionURL()->String{
        return "\(redirectURL)\(slug ?? "")"
    }
    
}

