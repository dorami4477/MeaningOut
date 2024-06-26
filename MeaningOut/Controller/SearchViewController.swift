//
//  MainViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit
import SnapKit


final class SearchViewController: BaseViewController {

    private let mainView = SearchView()
    
    override func loadView() {
        view = mainView
    }
    
    var recentSearchTerms:[String] = UserDefaultsManager.searchTerms
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if recentSearchTerms.count == 0{
            mainView.collectionView.isHidden = true
        }else{
            mainView.collectionView.isHidden = false
        }
        guard let name = UserDefaultsManager.nickName else { return }
        navigationItem.title = "\(name)'s FavoriteBOX"
        mainView.collectionView.reloadData()
    }
    
    
    override func configureView(){
        let searchCon = UISearchController(searchResultsController: nil)
        searchCon.searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        self.navigationItem.searchController = searchCon
        self.navigationController?.navigationBar.shadowImage = nil
        searchCon.searchBar.delegate = self
        guard let name = UserDefaultsManager.nickName else { return }
        navigationItem.title = "\(name)'s FavoriteBOX"
    }
    
    //*** 컬렉션 전체 삭제 버튼 만들기
    //전체 삭제 액션
    @objc private func deleteAllButtonClicked(){
        recentSearchTerms.removeAll()
        UserDefaultsManager.searchTerms = []
        //tableView.isHidden = true
    }
    
    //셀 삭제 액션
    @objc private func deleteButtonClicked(_ sender:UIButton){
        recentSearchTerms.remove(at:sender.tag)
        UserDefaultsManager.searchTerms = recentSearchTerms
        if recentSearchTerms.count == 0{
            mainView.collectionView.isHidden = true
        }else{
            mainView.collectionView.reloadData()
        }
    }
    
    private func configureCollectionView(){
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(RecentSearchTermCell.self, forCellWithReuseIdentifier: RecentSearchTermCell.identifier)
    }
}

extension SearchViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchTermCell.identifier, for: indexPath) as? RecentSearchTermCell else {
                    return .zero
                }
                cell.titleLabel.text = recentSearchTerms[indexPath.row]
                cell.titleLabel.sizeToFit()
                cell.deleteButton.sizeToFit()
                
                let cellWidth = cell.titleLabel.frame.width + cell.deleteButton.frame.width + 35

                return CGSize(width: cellWidth, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentSearchTerms.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchTermCell.identifier, for: indexPath) as! RecentSearchTermCell
            cell.setData(indexRow: indexPath.row, title: recentSearchTerms[indexPath.row])
            cell.deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let searchVC = SearchResultViewController()
        searchVC.searchTerm = recentSearchTerms[indexPath.row]
        navigationController?.pushViewController(searchVC, animated: true)
    }
       
}



// MARK: - TableView
extension SearchViewController:UITableViewDelegate, UITableViewDataSource{
    
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
extension SearchViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("엔터")
        let searchResultVC = SearchResultViewController()
        guard let text = searchBar.text else { return }
        print(text)
        if !text.trimmingCharacters(in: .whitespaces).isEmpty{
            searchResultVC.searchTerm = text
            
            //중복된 값 제거
            if let index = recentSearchTerms.firstIndex(where:{ $0 == text }){
                recentSearchTerms.remove(at: index)
            }
            
            recentSearchTerms.insert(text, at:0)
            UserDefaultsManager.searchTerms = recentSearchTerms
            
            navigationController?.pushViewController(searchResultVC, animated: true)
            searchBar.text = ""
            
        }
    }
}
