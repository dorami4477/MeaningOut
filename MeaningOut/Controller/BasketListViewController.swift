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
    var favoriteList:[Item] = []{
        didSet{
            searhResult = favoriteList
        }
    }
    var searhResult:[Item] = []{
        didSet{
            mainView.resultCountLabel.text = searhResult.count.formatted() + "개의 즐겨찾기"
            if searhResult.count == 0{
                mainView.resultCountLabel.isHidden = true
                mainView.collectionView.isHidden = true
            }else{
                mainView.resultCountLabel.isHidden = false
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
        navigationItem.title = "즐겨찾기"
        congfigureSearchBar()
        mainView.filterStackView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchItems()
    }

    func congfigureSearchBar(){
        let searchCon = UISearchController(searchResultsController: nil)
        searchCon.searchBar.placeholder = "즐겨찾기한 상품을 검색하세요."
        self.navigationItem.searchController = searchCon
        self.navigationController?.navigationBar.shadowImage = nil
        searchCon.searchBar.autocapitalizationType = .none
        searchCon.searchBar.autocorrectionType = .no
        searchCon.searchBar.delegate = self
    }
    
    private func configureCollectionView(){
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)
    }
    
    private func fetchItems(){
        let favoriteData = repository.fetchAllItem()
        
        favoriteData?.forEach{ data in
            let item = Item(title: data.title, link: data.link, image: data.image, lprice: data.lprice, hprice: data.hprice, mallName: data.mallName, productId: data.productId, productType: data.productType, brand: data.brand, maker: data.maker, category1: data.category1, category2: data.category2, category3: data.category3, category4: data.category4)
            favoriteList.append(item)
        }
    }
    
}


extension BasketListViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    //셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searhResult.count
    }
    
    //셀 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
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
        let detailVC = ItemDetailViewController()
        detailVC.data = searhResult[indexPath.item]
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


extension BasketListViewController:FavoriteDelegate{
    func resetFavButton(_ id:String, isFavorite:Bool) {
        guard let index = searhResult.firstIndex(where: { $0.productId == id }) else { return }
        let data = searhResult[index]
        let newData = ShoppingTable(productId: data.productId, title: data.title, link: data.link, image: data.image, lprice: data.lprice, hprice: data.hprice, mallName: data.mallName, productType: data.productType, brand: data.brand, maker: data.maker, category1: data.category1, category2: data.category2, category3: data.category2, category4: data.category4)
        if isFavorite{
            repository.createData(data:newData)
        }else{
            repository.deleteData(data:newData)
        }
        mainView.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
}


extension BasketListViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searhResult = favoriteList.filter{$0.titleBoldTag.lowercased().contains(searchText.lowercased())}
        mainView.collectionView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searhResult = favoriteList
        searchBar.text = ""
        
        mainView.collectionView.reloadData()
    }
}
