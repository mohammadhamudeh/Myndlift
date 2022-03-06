//
//  MovieTableViewCell.swift
//  Myndlift
//
//  Created by Mohammad Hamudeh on 03/03/2022.
//

import UIKit
import SDWebImage
class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var oviewViewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var imageURL = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        oviewViewLabel.numberOfLines = 3
        //        movieImage.image = UIImage()
        // Initialization code
    }
    func updateCell(moive:Movie){
        ratingLabel.text = "\(moive.rating ?? 0)"
        titleLabel.text = moive.title
        oviewViewLabel.text = moive.overview
        DispatchQueue.global(qos: .userInteractive).async{
            self.movieImage.sd_setImage(with: moive.getImageURL(), placeholderImage: UIImage(named: "playlist"), options: .progressiveLoad)
        }
//        imageURL = moive.getImageURL()
      
    }
    func updateImage(){
        
//
//        do{
//            Service.instance.updateImage(imageURL: imageURL, withCompletion: { image, error in
//                DispatchQueue.main.async { [self] in
//                    self.movieImage.image = UIImage(data: image!)
//
//                }
//            })
//        }catch{
//
//        }
//
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = UIImage(named: "playlist")
        titleLabel.text = ""
        ratingLabel.text = ""
        oviewViewLabel.text = ""
        
    }
}
