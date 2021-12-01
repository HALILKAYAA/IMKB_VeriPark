
import UIKit
import SideMenu
import CryptoSwift

class MainVC: UIViewController {
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .large
        spinner.color = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: nil)
        vc.searchBar.placeholder = "Ara"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        vc.obscuresBackgroundDuringPresentation = false
        vc.searchBar.sizeToFit()
        return vc
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StocksTableViewCell.self,
                           forCellReuseIdentifier: StocksTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    var menu: SideMenuNavigationController?
    
    private var stocks: [Stock]?
    private var filteredStocks = [Stock]()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    var period = "all"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        configure()
        let vc = MenuListController()
        vc.delegate = self
        menu = SideMenuNavigationController(rootViewController: vc)
        setupMenu()
        
        APICaller.shared.fetchStocks(period: period ,completion: {[weak self] result in
            switch result {
            case .success(let stocks):
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    self?.tableView.isHidden = false
                    self?.stocks = stocks
                    self?.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        spinner.center = view.center
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredStocks = (stocks?.filter { (stock: Stock) -> Bool in
            return stock.symbol.lowercased().contains(searchText.lowercased())
        })!
        tableView.reloadData()
    }

    private func configure() {
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(spinner)
        spinner.startAnimating()
    }

    private func setupNavbar() {
        title = "IMKB Hisse Senetleri/Endeksler"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3"),
            style: .plain,
            target: self,
            action: #selector(didTapMenu)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func setupMenu() {
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: true)
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    @objc private func didTapMenu() {
        let vc = MenuListController()
        vc.delegate = self
        present(menu!, animated: true)
    }
}

extension MainVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredStocks.count
        }
        return stocks?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StocksTableViewCell.identifier,
            for: indexPath
        ) as? StocksTableViewCell
        else {
            return UITableViewCell()
        }
        if indexPath.row%2 == 0 {
            cell.backgroundColor = .systemBackground
        } else
        {
            cell.backgroundColor = .secondarySystemBackground
        }
        let stock: Stock
        if isFiltering {
            stock = filteredStocks[indexPath.row]
        } else {
            stock = (stocks?[indexPath.row])!
        }
        cell.configure(stock: stock)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let stock = stocks?[indexPath.row] else {return}
        let id = String(stock.id)
        APICaller.shared.getDetailsStock(with: id, completion: {[weak self] result in
            switch result {
            case .failure(let error): print(error.localizedDescription)
            case .success(let stock):
                DispatchQueue.main.async {
                    let vc = DetailsVC(stock: stock)
                    vc.modalPresentationStyle = .fullScreen
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        })
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var labelArray = [UILabel]()
        let headerTitle = ["Sembol", "Fiyat", "Fark", "Hacim", "Alış", "Satış", "Değişim"]
        for i in 0..<7 {
            let label = UILabel()
            label.text = headerTitle[i]
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 12, weight: .regular)
            label.widthAnchor.constraint(equalToConstant: view.width).isActive = true
            label.heightAnchor.constraint(equalToConstant: 50).isActive = true
            labelArray.append(label)
        }
        let stackView = UIStackView(arrangedSubviews: labelArray)
        stackView.frame = CGRect(x: 0, y: 0, width: view.width, height: 50)
        stackView.center = view.center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .secondarySystemBackground
        return stackView
    }
}

extension MainVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension MainVC: MenuListControllerDelegate {
    func clickedMenu(with period: String) {
        self.period = period
        APICaller.shared.fetchStocks(period: period ,completion: {[weak self] result in
            switch result {
            case .success(let stocks):
                DispatchQueue.main.async {
                    self?.stocks = stocks
                    self?.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        })
    }
}
