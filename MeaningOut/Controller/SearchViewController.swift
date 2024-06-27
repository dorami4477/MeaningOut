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
            mainView.headerView.isHidden = true
            mainView.collectionView.isHidden = true
        }else{
            mainView.headerView.isHidden = false
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
    
    //전체 삭제 액션
    @objc private func deleteAllButtonClicked(){
        showAlert(title: "전체 삭제", message: "정말로 삭제하시겠습니까?", buttonTilte: "삭제") { _ in
            self.recentSearchTerms.removeAll()
            UserDefaultsManager.searchTerms = []
            self.mainView.headerView.isHidden = true
            self.mainView.collectionView.isHidden = true
        }
    }
    
    //셀 삭제 액션
    @objc private func deleteButtonClicked(_ sender:UIButton){
        recentSearchTerms.remove(at:sender.tag)
        UserDefaultsManager.searchTerms = recentSearchTerms
        if recentSearchTerms.count == 0{
            mainView.headerView.isHidden = true
            mainView.collectionView.isHidden = true
        }else{
            mainView.collectionView.reloadData()
        }
    }
    
    private func configureCollectionView(){
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.deleteButton.addTarget(self, action: #selector(deleteAllButtonClicked), for: .touchUpInside)
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




// MARK: - SearchBar
extension SearchViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let searchResultVC = SearchResultViewController()
        guard let text = searchBar.text else { return }
    
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
