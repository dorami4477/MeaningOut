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

    var searchTerm = ""
    private var sort = "sim"
    private var startNum = 1
    
    let networkManager = NetworkManger.shared
    
    var searhResult:Shopping?{
        didSet{
            guard let searhResult else { return }
            resultCountLabel.text = searhResult.total.formatted() + "개의 검색 결과"
            if searhResult.total == 0{
                collectionView.isHidden = true
            }else{
                collectionView.isHidden = false
            }
        }
    }
    
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
        label.text = "찾으시는 상품이 없습니다."
        return label
    }()
    
    private let resultCountLabel = {
        let label = UILabel()
        label.textColor = AppColor.primary
        label.font = AppFont.size13Bold 
        return label
    }()
    
    private let filter01Button = FilterButton(title: FilterName.sim.rawValue)
    private let filter02Button = FilterButton(title: FilterName.date.rawValue)
    private let filter03Button = FilterButton(title: FilterName.dsc.rawValue)
    private let filter04Button = FilterButton(title: FilterName.asc.rawValue)
    
    private lazy var filterButtons:[FilterButton] = [filter01Button, filter02Button, filter03Button, filter04Button]
    
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
        collectionView.reloadData()
    }
    
    
    override func configureHierarchy(){
        [resultCountLabel, filterStackView, emptyImg, emptyLebel, collectionView ].forEach { view.addSubview($0) }
        [filter01Button, filter02Button, filter03Button,filter04Button ].forEach { filterStackView.addArrangedSubview($0) }
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
    

    private func showSkeletonView(){
        collectionView.isSkeletonable = true
        collectionView.showAnimatedGradientSkeleton()
    }

    //네트워크
    func sucessNetwork(_ value: Shopping){
        if self.startNum == 1{
            self.searhResult = value
        }else{
            self.searhResult?.items.append(contentsOf: value.items)
        }
    
        self.collectionView.reloadData()
        
        if self.startNum == 1 && self.searhResult?.total != 0{
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        //스켈레톤뷰 종료
        self.collectionView.stopSkeletonAnimation()
        self.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
    }
    
}


// MARK: - filter
extension SearchResultViewController{
    
    private func setfilterButton(){
        filterButtons.forEach {
            $0.addTarget(self, action: #selector(filterTapped(_:)), for: .touchUpInside)
        }
    }
    
    //필터 액션
    @objc private func filterTapped(_ sender:FilterButton){
        switch sender{
        case filter01Button:
            sort = "\(FilterName.sim)"
        case filter02Button:
            sort = "\(FilterName.date)"
        case filter03Button:
            sort = "\(FilterName.dsc)"
        case filter04Button:
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
        
        filterButtons.forEach {
            $0.updateButtonAppearance(false, title: $0.currentTitle!)
        }
        sender.updateButtonAppearance(true, title: sender.currentTitle!)
    }

}


// MARK: - CollectionView Setting
extension SearchResultViewController{
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)
    }
    
    //컬렉션뷰 레이아웃
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

