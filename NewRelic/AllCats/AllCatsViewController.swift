//
//  AllCatsViewController.swift
//  NewRelic
//
//  Created by newrelic on 8/15/20.
//  Copyright © 2020 newrelic. All rights reserved.
//

import UIKit

class AllCatsViewController: UIViewController, AlertPresenter {

    @IBOutlet weak var tableView: UITableView!

    private var isDisplayingAlert = false
    private let viewModel: AllCatsViewModel
    private let refreshControl = UIRefreshControl()

    init?(coder: NSCoder, viewModel: AllCatsViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a View Model.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Metrics",
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(self.rightButtonTapped(sender:)))
        setupTableView()
    }

}

extension AllCatsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCats()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as? CatTableViewCell

        if let breed = viewModel.catForIndexPath(indexPath)?.breed {
            if breed == "" {
                cell?.configure(name: breed, state: .loading)
            } else {
                cell?.configure(name: breed, state: .done)
            }
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let catDetail = viewModel.catForIndexPath(indexPath) else { return }
        displayCatDetailsViewControllerWithCatDetail(catDetail)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let beginRefreshAtRow = viewModel.numberOfCats() - 20
        if indexPath.row >= beginRefreshAtRow &&
            viewModel.isAbleToDownloadMoreCats() == true {
            requestMoreCats()
        }
    }

}

private extension AllCatsViewController {

    func setupTableView() {
        refreshControl.addTarget(self, action: #selector(self.refreshPullDownTriggered(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140

        requestMoreCats()
    }

    @objc func refreshPullDownTriggered(_ sender: AnyObject) {
        if viewModel.didFetchAllCats() {
            refreshControl.endRefreshing()
        } else {
            requestMoreCats()
        }
    }

    func requestMoreCats() {
        viewModel.getMoreCats { [weak self] error in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            if let error = error as? ConnectionError {
                if self.isDisplayingAlert == false {
                    self.isDisplayingAlert = true
                    self.displayError(error)
                }
            }
            self.tableView.reloadData()
        }
    }

    func displayError(_ error: ConnectionError) {
        var errorMessage: String
        switch error {
        case .apiRateLimitReached:
            errorMessage = "You've reached the maximum amount of API calls. Please try again later."
        case .noInternetConnection:
            errorMessage = "Please check your internet connection and try to refresh the data."
        }
        self.showSimpleAlertWithNoTitle(message: errorMessage, buttonTitle: "OK") { [weak self] in
            self?.isDisplayingAlert = false
        }
    }

    func displayCatDetailsViewControllerWithCatDetail(_ cat: CatDetail) {
        let board = UIStoryboard(name: "Main", bundle: nil)
        let catDetailsViewModel = CatDetailsViewModel(catDetail: cat)
        let detailsView = board.instantiateViewController(identifier: "CatDetailsViewController") { coder in
            CatDetailsViewController(coder: coder, viewModel: catDetailsViewModel)
        }
        navigationController?.pushViewController(detailsView, animated: true)
    }

    @objc func rightButtonTapped(sender: UIBarButtonItem) {
        displayMetricsViewController()
    }

    func displayMetricsViewController() {
        let board = UIStoryboard(name: "Main", bundle: nil)
        let metricsViewModel = MetricsViewModel(networkResponseTimes: viewModel.getNetworkResponseTimes())
        let metricsView = board.instantiateViewController(identifier: "MetricsViewController") { coder in
            MetricsViewController(coder: coder, viewModel: metricsViewModel)
        }
        navigationController?.pushViewController(metricsView, animated: true)
    }

}
