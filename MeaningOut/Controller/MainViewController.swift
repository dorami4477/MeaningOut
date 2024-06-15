//
//  MainViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {


    let emptyImg = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let tableView = UITableView()
    
    var recentSearchTerms:[String] = UserDefaultsManager.searchTerms
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
        print(UserDefaultsManager.signUpDate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if recentSearchTerms.count == 0{
            tableView.isHidden = true
        }else{
            tableView.isHidden = false
        }
        
        tableView.reloadData()
    }
    private func configureHierarchy(){
        view.addSubview(emptyImg)
        view.addSubview(tableView)
    }
    private func configureLayout(){
        emptyImg.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = UserDefaultsManager.nickName! + "'s MEANING OUT"
        let searchCon = UISearchController(searchResultsController: nil)
        searchCon.searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        self.navigationItem.searchController = searchCon
        self.navigationController?.navigationBar.shadowImage = nil
        searchCon.searchBar.delegate = self
    }
    private func configureTableView(){
        if recentSearchTerms.count == 0{
            tableView.isHidden = true
        }else{
            tableView.isHidden = false
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecentSearchCell.self, forCellReuseIdentifier: RecentSearchCell.identifier)
        tableView.register(RecentSearchHeader.self, forHeaderFooterViewReuseIdentifier: RecentSearchHeader.identifier)
        tableView.sectionHeaderHeight = 56
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
    }
    
    @objc func deleteAllButtonClicked(){
        recentSearchTerms.removeAll()
        UserDefaultsManager.searchTerms = []
        tableView.isHidden = true
    }
    
    @objc func deleteButtonClicked(_ sender:UIButton){
        recentSearchTerms.remove(at:sender.tag)
        UserDefaultsManager.searchTerms = recentSearchTerms
        if recentSearchTerms.count == 0{
            tableView.isHidden = true
        }else{
            tableView.reloadData()
        }
    }
}

// MARK: - TableView
extension MainViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecentSearchHeader.identifier) as! RecentSearchHeader
        cell.deleteButton.addTarget(self, action: #selector(deleteAllButtonClicked), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchTerms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as! RecentSearchCell
        cell.selectionStyle = .none
        cell.titleLabel.text = recentSearchTerms[indexPath.row]
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchVC = SearchResultViewController()
        searchVC.searchTerm = recentSearchTerms[indexPath.row]
        navigationController?.pushViewController(searchVC, animated: true)
    }
    

}

// MARK: - SearchBar
extension MainViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchVC = SearchResultViewController()
        guard let text = searchBar.text else { return }
        searchVC.searchTerm = text
        recentSearchTerms.append(text)
        UserDefaultsManager.searchTerms = recentSearchTerms
        navigationController?.pushViewController(searchVC, animated: true)
    }
}
