//
//  TitleAndValueTableViewCell.swift
//  NewRelic
//
//  Copyright © 2022 newrelicchallenge. All rights reserved.
//

import UIKit

struct TitleLabelAndValueLabel {
    let titleLabelText: String
    let valueLabelText: String
}

class TitleAndValueTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(_ titleAndValue: TitleLabelAndValueLabel) {
        detailLabel.text = titleAndValue.titleLabelText
        detailValue.text = titleAndValue.valueLabelText
    }

}
