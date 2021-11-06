//
//  DetailViewController.swift
//  TreinamentoIOS
//
//  Created by COTEMIG on 30/10/21.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var sinopseLabel: UILabel!
    
    public var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleName.text = movie?.title
        sinopseLabel.text = movie?.overview
        
        let imagePath = Constants.imageURL.rawValue + (movie?.posterPath ?? "")
        if let imageURL = URL(string: imagePath) {
            imageMovie.kf.setImage(with: imageURL)
        }        
    }

}
