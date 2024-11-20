//
//  StockListViewController.swift
//  StockList
//
//  Created by Piyush Pandey on 19/11/24.
//

import UIKit

final class StockListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel = StockListViewModel()
    private var stocks = [Stock]()
    private lazy var alertPresenter = AlertPresenter(viewController: self)
    private let refreshControl = UIRefreshControl()
    private let portfolioSummaryDrawerView = PortfolioSummaryDrawerView()
    
    private var isLoading = true {
        didSet {
            self.handleLoadingStateChange()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        style()
        layout()
        fetchStocks()
        setupRefreshControl()
    }
    
    private func createNavView() -> UIStackView {
        let stackView = UIStackView()
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 35),
            imageView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        let titleLabel = UILabel()
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.textColor = .white
        titleLabel.text = "Portfolio"
        stackView.spacing = 12
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        return stackView
    }
    
    private func style() {
        view.backgroundColor = .systemBlue
        
        navigationItem.titleView = createNavView()
        navigationController?.navigationBar.barTintColor = .systemBlue
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.separatorColor = .systemGray
        tableView.allowsSelection = false
        tableView.rowHeight = 120
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: StockTableViewCell.identifier)
        tableView.register(ShimmerLoadTableViewCell.self, forCellReuseIdentifier: ShimmerLoadTableViewCell.identifier)
        
        portfolioSummaryDrawerView.translatesAutoresizingMaskIntoConstraints = false
        portfolioSummaryDrawerView.isHidden = true
    }
    
    private func layout() {
        view.addSubview(tableView)
        view.addSubview(portfolioSummaryDrawerView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 0),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: tableView.bottomAnchor, multiplier: 1),
            
            portfolioSummaryDrawerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            portfolioSummaryDrawerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            portfolioSummaryDrawerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func handleLoadingStateChange() {
        DispatchQueue.main.async {
            if !self.isLoading {
                self.portfolioSummaryDrawerView.configure(with: self.viewModel.stockSummary)
                self.portfolioSummaryDrawerView.isHidden = false
                self.refreshControl.endRefreshing()
            } else {
                self.portfolioSummaryDrawerView.isHidden = true
            }
            self.tableView.isScrollEnabled = !self.isLoading
            self.tableView.reloadData()
        }
    }
}

// MARK: TableView Delegate Methods
extension StockListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !isLoading else {
            return 10
        }
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !isLoading else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShimmerLoadTableViewCell.identifier,
                                                     for: indexPath) as! ShimmerLoadTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.identifier, for: indexPath) as! StockTableViewCell
        let stock = stocks[indexPath.row]
        cell.configure(with: stock)
        return cell
    }
}

// MARK: Loading Data From ViewModel
extension StockListViewController {
    private func fetchStocks() {
        isLoading = true
        viewModel.fetchStocks { [weak self] stocks, error in
            guard let self else { return }
            if let stocks {
                self.stocks = stocks
                isLoading = false
            } else if let error {
                self.alertPresenter.showError(error) {
                    self.fetchStocks()
                }
            }
        }
    }
}

// MARK: Configure Pull To Refresh
extension StockListViewController {
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refersh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refersh() {
        fetchStocks()
    }
}
