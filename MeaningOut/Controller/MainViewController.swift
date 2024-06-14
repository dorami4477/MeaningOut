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
    
    var recentSearchTerms:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
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
    }
    private func configureTableView(){
       /* if recentSearchTerms.count == 0{
            tableView.isHidden = true
        }else{
            tableView.isHidden = false
        }*/
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecentSearchCell.self, forCellReuseIdentifier: RecentSearchCell.identifier)
        tableView.register(RecentSearchHeader.self, forHeaderFooterViewReuseIdentifier: RecentSearchHeader.identifier)
        tableView.sectionHeaderHeight = 56
    }
    
}


extension MainViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecentSearchHeader.identifier) as! RecentSearchHeader
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as! RecentSearchCell
        
        return cell
    }
    
    
}
