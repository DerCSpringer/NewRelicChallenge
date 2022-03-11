//
//  CatDetailsViewController.swift
//  NewRelic
//
//  Created by newrelic on 8/16/20.
//  Copyright © 2020 newrelic. All rights reserved.
//

import Foundation

import UIKit

class CatDetailsViewController: UIViewController {

    private var viewModel: CatDetailsViewModel?
        
    @IBOutlet weak var tableView: UITableView!

    init?(coder: NSCoder, viewModel: CatDetailsViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a View Model.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        tableView.separatorStyle = .none
        tableView.bounces = false
    }
}

extension CatDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        // breed, country, origin, coat, pattern => 5
        return 5
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatDetailCell",
                                                 for: indexPath) as? TitleAndValueTableViewCell

        guard var viewModel = viewModel else { return UITableViewCell() }

        switch indexPath.row {
        case 0:
            cell?.configure(TitleLabelAndValueLabel(titleLabelText: "breed",
                                                    valueLabelText: viewModel.breed))
        case 1:
            cell?.configure(TitleLabelAndValueLabel(titleLabelText: "country",
                                                    valueLabelText: viewModel.country))
        case 2:
            cell?.configure(TitleLabelAndValueLabel(titleLabelText: "origin",
                                                    valueLabelText: viewModel.origin))
        case 3:
            cell?.configure(TitleLabelAndValueLabel(titleLabelText: "coat",
                                                    valueLabelText: viewModel.coat))
        case 4:
            cell?.configure(TitleLabelAndValueLabel(titleLabelText: "pattern",
                                                    valueLabelText: viewModel.pattern))
        default:
            cell?.configure(TitleLabelAndValueLabel(titleLabelText: "label",
                                                    valueLabelText: "value"))
        }

        cell?.selectionStyle = .none
        return cell!
    }
    
}
