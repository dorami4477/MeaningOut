//
//  BasketListViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/19/24.
//


import UIKit


final class BasketListViewController: BaseViewController {
    
    private let mainView = SearchResultView()
    let repository = ShoppingRepository()
    var searhResult:[ShoppingTable]?{
        didSet{
            guard let searhResult else { return }
            mainView.resultCountLabel.text = searhResult.count.formatted() + "개의 즐겨찾기"
            if searhResult.count == 0{
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
        configureCollectionView()
        setfilterButton()
        navigationItem.title = "즐겨찾기"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searhResult = repository.fetchAllItem()
    }

    
    private func setfilterButton(){
        mainView.filterButtons.forEach {
            $0.addTarget(self, action: #selector(filterTapped(_:)), for: .touchUpInside)
        }
    }
    
    //필터 액션
    @objc private func filterTapped(_ sender:FilterButton){

    }
    
    private func configureCollectionView(){
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)
    }
    
}


extension BasketListViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    //셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searhResult?.count ?? 0
    }
    
    //셀 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
        guard let searhResult else { return UICollectionViewCell()}
        if repository.fetchSingleItem(searhResult[indexPath.item].productId) != nil{
            cell.favorite = true
        }else{
            cell.favorite = false
        }
        cell.data = searhResult[indexPath.item]
        return cell
    }
    
    //셀 클릭시
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("셀이 클릭됨")
     /*   guard let searhResult else { return }
        let detailVC = ItemDetailViewController()
        detailVC.data = searhResult[indexPath.item]
        //detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)*/
    }
}
