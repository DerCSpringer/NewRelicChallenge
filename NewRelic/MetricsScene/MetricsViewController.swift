//
//  MetricsViewController.swift
//  NewRelic
//
//  Created by newrelic on 8/16/20.
//  Copyright © 2020 newrelic. All rights reserved.
//

import Foundation
import UIKit


class MetricsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: MetricsViewModel?

    init?(coder: NSCoder, viewModel: MetricsViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a View Model.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Metrics"
        setupTableView()
    }

}

extension MetricsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        // average response time, make/model, os version => 3
        return 3
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let viewModel = viewModel else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "MetricsCell",
                                                 for: indexPath) as? TitleAndValueTableViewCell

        switch indexPath.row {
        case 0:
            cell?.configure(TitleLabelAndValueLabel(titleLabelText: "avg http response time(ms)",
                                                    valueLabelText: formatedAverageNetworkResponseTime()))
        case 1:
            cell?.configure(TitleLabelAndValueLabel(titleLabelText: "Device model",
                                                    valueLabelText: viewModel.modelIdentifier()))
        case 2:
            cell?.configure(TitleLabelAndValueLabel(titleLabelText: "OS version",
                                                    valueLabelText: UIDevice.current.systemVersion))
        default:
            cell?.configure(TitleLabelAndValueLabel(titleLabelText: "label",
                                                    valueLabelText: "value"))
        }

        return cell!
    }

}

private extension MetricsViewController {

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        tableView.separatorStyle = .none
        tableView.bounces = false
    }

    func formatedAverageNetworkResponseTime() -> String {
        guard let viewModel = viewModel else { return "" }
        var averageTime: String
        if viewModel.networkDidTimeout() {
            averageTime = "Timeout"
        } else {
            let averageResponseTimeInMS = viewModel.averageNetworkResponseTime() * 1000.0
            averageTime = String(format: "%.0f", averageResponseTimeInMS)
        }
        return averageTime
    }
}
