//
//  ActorCell.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 26.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import UIKit
import SDWebImage
class ActorCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(actor: ActorPresentation) {
        self.nameLabel.text = actor.name
        imageView.sd_setImage(with: actor.image, placeholderImage: UIImage(named: "actor-ph"))
    }
}
