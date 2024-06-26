//
//  MainViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit
import SnapKit

enum NicknameValidationError:Error{
    case lengthOver10
    case specialLetters
    case integer
    case lengthUnder2
    
    var message:String{
        switch self {
        case .lengthOver10:
            return "2글자 이상 10글자 미만으로 설정해주세요."
        case .specialLetters:
            return "닉네임에 @, #, $, % 는 포함할 수 없어요."
        case .integer:
            return "닉네임에 숫자는 포함 할 수 없어요."
        case .lengthUnder2:
            return "2글자 이상 10글자 미만으로 설정해주세요."
        }

    }
}


final class MainViewController: BaseViewController {

    private let emptyImg = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emptyLebel = {
        let label = UILabel()
        label.font = AppFont.size16Bold 
        label.textAlignment = .center
        label.text = "최근 검색어가 없어요."
        return label
    }()
    
    private let tableView = UITableView()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout())
    
    var recentSearchTerms:[String] = UserDefaultsManager.searchTerms
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureCollectionView()
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if recentSearchTerms.count == 0{
            //tableView.isHidden = true
            collectionView.isHidden = true
        }else{
            //tableView.isHidden = false
            collectionView.isHidden = false
        }
        //tableView.reloadData()
        collectionView.reloadData()
    }
    
    
    override func configureHierarchy(){
        view.addSubview(emptyImg)
        view.addSubview(emptyLebel)
      //  view.addSubview(tableView)
    }
    override func configureLayout(){
        emptyImg.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalTo(view.snp.centerY)
            make.height.equalTo(emptyImg.snp.width).multipliedBy(0.75)
        }
        emptyLebel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(emptyImg.snp.bottom).offset(10)
        }
      /*  tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }*/
    }
    
    override func configureView(){
        let searchCon = UISearchController(searchResultsController: nil)
        searchCon.searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        self.navigationItem.searchController = searchCon
        guard let name = UserDefaultsManager.nickName else { return }
        navigationItem.title = "\(name)'s FavoriteBOX"
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
    
    //전체 삭제 액션
    @objc private func deleteAllButtonClicked(){
        recentSearchTerms.removeAll()
        UserDefaultsManager.searchTerms = []
        tableView.isHidden = true
    }
    
    //셀 삭제 액션
    @objc private func deleteButtonClicked(_ sender:UIButton){
        recentSearchTerms.remove(at:sender.tag)
        UserDefaultsManager.searchTerms = recentSearchTerms
        if recentSearchTerms.count == 0{
            //tableView.isHidden = true
            collectionView.isHidden = true
        }else{
            //tableView.reloadData()
            collectionView.reloadData()
        }
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecentSearchTermCell.self, forCellWithReuseIdentifier: RecentSearchTermCell.identifier)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
}

extension MainViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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
    
    func flowLayout() -> UICollectionViewLayout{
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        return layout
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
        
        if !text.trimmingCharacters(in: .whitespaces).isEmpty{
            searchVC.searchTerm = text
            
            //중복된 값 제거
            if let index = recentSearchTerms.firstIndex(where:{ $0 == text }){
                recentSearchTerms.remove(at: index)
            }
            
            recentSearchTerms.insert(text, at:0)
            UserDefaultsManager.searchTerms = recentSearchTerms
            
            navigationController?.pushViewController(searchVC, animated: true)
            searchBar.text = ""
        }
    }
    
}
