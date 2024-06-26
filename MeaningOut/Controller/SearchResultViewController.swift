//
//  SearchResultViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/14/24.
//

import UIKit
import Alamofire
import SkeletonView

final class SearchResultViewController: BaseViewController{

    private let mainView = SearchResultView()
    
    var searchTerm = ""
    private var sort = "sim"
    private var startNum = 1
    
    let networkManager = NetworkManger.shared
    
    var searhResult:Shopping?{
        didSet{
            guard let searhResult else { return }
            mainView.resultCountLabel.text = searhResult.total.formatted() + "개의 검색 결과"
            if searhResult.total == 0{
                mainView.collectionView.isHidden = true
            }else{
                mainView.collectionView.isHidden = false
            }
        }
    }
    
    override func loadView() {
        view = mainView
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        showSkeletonView()
        configureCollectionView()
        setfilterButton()
        navigationItem.title = searchTerm
        networkManager.callRequest(searchTerm: searchTerm, sort: sort, startNum: startNum) { result in
            switch result {
            case .success(let value):
                self.sucessNetwork(value)
            case .failure :
                self.showToast(message: "네트워크 통신이 실패하였습니다.\n 잠시 후 다시 시도해주세요.")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.collectionView.reloadData()
    }
    
    

    

    private func showSkeletonView(){
        mainView.collectionView.isSkeletonable = true
        mainView.collectionView.showAnimatedGradientSkeleton()
    }

    //네트워크
    func sucessNetwork(_ value: Shopping){
        if self.startNum == 1{
            self.searhResult = value
        }else{
            self.searhResult?.items.append(contentsOf: value.items)
        }
    
        self.mainView.collectionView.reloadData()
        
        if self.startNum == 1 && self.searhResult?.total != 0{
            self.mainView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        //스켈레톤뷰 종료
        self.mainView.collectionView.stopSkeletonAnimation()
        self.mainView.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
    }
    
}


// MARK: - filter
extension SearchResultViewController{
    
    private func setfilterButton(){
        mainView.filterButtons.forEach {
            $0.addTarget(self, action: #selector(filterTapped(_:)), for: .touchUpInside)
        }
    }
    
    //필터 액션
    @objc private func filterTapped(_ sender:FilterButton){
        switch sender{
        case mainView.filter01Button:
            sort = "\(FilterName.sim)"
        case mainView.filter02Button:
            sort = "\(FilterName.date)"
        case mainView.filter03Button:
            sort = "\(FilterName.dsc)"
        case mainView.filter04Button:
            sort = "\(FilterName.asc)"
        default:
            print("error")
        }
        
        startNum = 1
        showSkeletonView()
        networkManager.callRequest(searchTerm: searchTerm, sort: sort, startNum: startNum) { result in
            switch result {
            case .success(let value):
                self.sucessNetwork(value)
            case .failure :
                self.showToast(message: "네트워크 통신이 실패하였습니다.\n 잠시 후 다시 시도해주세요.")
            }
        }
        
        mainView.filterButtons.forEach {
            $0.updateButtonAppearance(false, title: $0.currentTitle!)
        }
        sender.updateButtonAppearance(true, title: sender.currentTitle!)
    }

}


// MARK: - CollectionView Setting
extension SearchResultViewController{
    private func configureCollectionView(){
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.prefetchDataSource = self
        mainView.collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)
    }
    

}

// MARK: - CollectionView + skeleton Delegate
extension SearchResultViewController:SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource{
    
    //skeleton 함수
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return SearchResultCell.identifier
    }

    
    //셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let resultItems = searhResult?.items else { return 0 }

        return resultItems.count
    }
    
    //셀 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
        guard let resultItems = searhResult?.items else { return UICollectionViewCell() }
        
        if let fav = UserDefaultsManager.favorite[resultItems[indexPath.item].productId]{
            cell.favorite = fav
        }else{
            UserDefaultsManager.favorite[resultItems[indexPath.item].productId] = false
            cell.favorite = false
        }
        
        cell.data = resultItems[indexPath.item]
        cell.changeText(text: searchTerm)
        return cell
    }
    
    //셀 클릭시
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let resultItems = searhResult?.items else { return }
        let detailVC = ItemDetailViewController()
        detailVC.data = resultItems[indexPath.item]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


// MARK: - CollectionViewPrefetching
extension SearchResultViewController:UICollectionViewDataSourcePrefetching{
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {

        guard let searhResult else { return }
        for item in indexPaths{
            if searhResult.items.count - 2 == item.item && searhResult.total != startNum{
                startNum += 30
                networkManager.callRequest(searchTerm: searchTerm, sort: sort, startNum: startNum) { result in
                    switch result {
                    case .success(let value):
                        self.sucessNetwork(value)
                    case .failure :
                        self.showToast(message: "네트워크 통신이 실패하였습니다.\n 잠시 후 다시 시도해주세요.")
                    }
                }
            }
        }
    }
    
}

