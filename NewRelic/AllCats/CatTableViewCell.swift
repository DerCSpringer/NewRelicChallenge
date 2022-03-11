//
//  CatTableViewCell.swift
//  NewRelic
//
//  Created by newrelic on 8/16/20.
//  Copyright © 2020 newrelic. All rights reserved.
//

import UIKit

enum AnimatingState {
    case loading
    case done
}

class CatTableViewCell: UITableViewCell {

    @IBOutlet weak var backing: UIView!
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(name: String, state: AnimatingState) {
        catName.text = name
        switch state {
            case .loading:
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
            case .done:
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backing.backgroundColor = highlighted ? UIColor.yellow : UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
