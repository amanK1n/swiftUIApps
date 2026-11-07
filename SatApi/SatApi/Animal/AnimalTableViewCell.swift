//
//  AnimalTableViewCell.swift
//  SatApi
//
//  Created by comviva on 07/11/26.
//

import UIKit

class AnimalTableViewCell: UITableViewCell {

    @IBOutlet weak var animalImgView: LazyImgView?
    @IBOutlet weak var animalNameLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        animalNameLabel?.isHidden = false
        animalImgView?.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
