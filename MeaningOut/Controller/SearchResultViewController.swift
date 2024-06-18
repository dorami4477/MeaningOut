//
//  SearchResultViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/14/24.
//

import UIKit
import Alamofire
import SkeletonView

final class SearchResultViewController: UIViewController {

    var searchTerm = ""
    private var sort = "sim"
    private var startNum = 1
    
    var searhResult:Shopping?{
        didSet{
            resultCountLabel.text = searhResult!.total.formatted() + "개의 검색 결과"
            if searhResult!.total == 0{
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
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "찾으시는 상품이 없습니다."
        return label
    }()
    
    private let resultCountLabel = {
        let label = UILabel()
        label.textColor = AppColor.primary
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let filter01Button = FilterButton(title: FilterName.accuracy.rawValue)
    private let filter02Button = FilterButton(title: FilterName.date.rawValue)
    private let filter03Button = FilterButton(title: FilterName.highest.rawValue)
    private let filter04Button = FilterButton(title: FilterName.lowest.rawValue)
    
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
        configureHierarchy()
        configureLayout()
        showSkeletonView()
        callRequest()
        configureCollectionView()
        setfilterButton()
        Basic.setting(self, title: searchTerm)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    
    private func configureHierarchy(){
        [resultCountLabel, filterStackView, emptyImg, emptyLebel, collectionView ].forEach { view.addSubview($0) }
        [filter01Button, filter02Button, filter03Button,filter04Button ].forEach { filterStackView.addArrangedSubview($0) }
    }
    
    private func configureLayout(){
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
                
                    self.collectionView.reloadData()
                    
                    
                    if self.startNum == 1 && self.searhResult?.total != 0{
                        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                        
                    }
                
                    //스켈레톤뷰 종료
                    self.collectionView.stopSkeletonAnimation()
                    self.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
              
                
            case .failure(let error):
                print(error)
                self.showToast(message: "네트워크 통신이 실패하였습니다.\n 잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    
    //토스트 메시지
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height - 200, width: 200, height: 65))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
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
            sort = "sim"
        case filter02Button:
            sort = "date"
        case filter03Button:
            sort = "dsc"
        case filter04Button:
            sort = "asc"
        default:
            print("error")
        }
        
        startNum = 1
        showSkeletonView()
        callRequest()
        
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
                callRequest()
            }
        }
    }
    
}

