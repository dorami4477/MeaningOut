//
//  SearchResultViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/14/24.
//

import UIKit
import Alamofire

final class SearchResultViewController: UIViewController {

    var searchTerm = ""
    var sort = "sim"
    
    var startNum = 1
    
    var searhResult:Shopping?{
        didSet{
            resultCountLabel.text = searhResult!.total.formatted() + "개의 검색 결과"
            collectionView.reloadData()
        }
    }
    
    let resultCountLabel = {
        let label = UILabel()
        label.textColor = AppColor.primary
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let filter01Button = FilterButton(title: "정확도")
    private let filter02Button = FilterButton(title: "날짜순")
    private let filter03Button = FilterButton(title: "가격높은순")
    private let filter04Button = FilterButton(title: "가격낮은순")
    
    private lazy var filterButtons:[UIButton] = [filter01Button, filter02Button, filter03Button, filter04Button]
    
    private lazy var filterStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .leading
        return sv
    }()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        callRequest()
        configureCollectionView()
        setfilterButton()
        Basic.setting(self, title: searchTerm)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    
    private func configureHierarchy(){
        [resultCountLabel, filterStackView, collectionView ].forEach { view.addSubview($0) }
        [filter01Button, filter02Button, filter03Button,filter04Button ].forEach { filterStackView.addArrangedSubview($0) }
    }
    private func configureLayout(){
        resultCountLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        filterStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(resultCountLabel.snp.bottom).offset(10)
        }
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(filterStackView.snp.bottom).offset(10)
        }
    }

    //네트워크
    private func callRequest(){
        let url = "\(APIInfo.url)query=\(searchTerm)&sort=\(sort)&display=30&start=\(startNum)"
        
        let header:HTTPHeaders = ["X-Naver-Client-Id": APIInfo.clientId, "X-Naver-Client-Secret": APIInfo.clientSecret]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: Shopping.self){ response in
            switch response.result{
            case .success(let value):
                
                if self.startNum == 1{
                    self.searhResult = value
                }else{
                    
                    self.searhResult?.items.append(contentsOf: value.items)
                }
                
                if self.startNum == 1 && self.searhResult?.total != 0{
                        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                  
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    


    private func setfilterButton(){
        filter01Button.backgroundColor = AppColor.gray01
        filter01Button.setTitleColor(AppColor.white, for: .normal)
        
        filterButtons.forEach {
            $0.addTarget(self, action: #selector(filterTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func filterTapped(_ sender:UIButton){
        switch sender{
        case filter01Button:
            sort = "sim"
            startNum = 1
            callRequest()
        case filter02Button:
            sort = "date"
            startNum = 1
            callRequest()
        case filter03Button:
            sort = "dsc"
            startNum = 1
            callRequest()
        case filter04Button:
            sort = "asc"
            startNum = 1
            callRequest()
        default:
            print("error")
        }
        
        filterButtons.forEach {
            $0.backgroundColor = AppColor.white
            $0.setTitleColor(AppColor.gray01, for: .normal)
            $0.layer.borderWidth = 1
        }
        
        sender.layer.borderWidth = 0
        sender.backgroundColor = AppColor.gray01
        sender.setTitleColor(AppColor.white, for: .normal)
    }
    
}

// MARK: - CollectionView
extension SearchResultViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout{
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionCellWidth = (UIScreen.main.bounds.width - ShoppingCell.spacingWidth * (ShoppingCell.cellColumns + 1)) / ShoppingCell.cellColumns
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth * 1.7)
        flowLayout.minimumLineSpacing = ShoppingCell.spacingWidth
        flowLayout.minimumInteritemSpacing = ShoppingCell.spacingWidth
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: ShoppingCell.spacingWidth, bottom: 0, right: ShoppingCell.spacingWidth)
        return flowLayout
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let resultItems = searhResult?.items else { return 0 }

        return resultItems.count
    }
    
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("클릭")
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
                callRequest()
            }
        }
    }
    
}
