//
//  SearchResultViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/14/24.
//

import UIKit
import Alamofire

class SearchResultViewController: UIViewController {

    var searchTerm:String = ""
    
    var searhResult:Shopping?
    
    let resultCountLabel = {
        let label = UILabel()
        label.textColor = AppColor.primary
        label.text = "22222개의 검색 결과"
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    
    let filter01Button = FilterButton(title: "정확도")
    let filter02Button = FilterButton(title: "날짜순")
    let filter03Button = FilterButton(title: "가격높은순")
    let filter04Button = FilterButton(title: "가격낮은순")
    
    lazy var filterStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .leading
        return sv
    }()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        callRequest()
        configureCollectionView()
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
    private func configureUI(){
        view.backgroundColor = .white
        title = searchTerm
        collectionView.backgroundColor = .blue
    }
    func callRequest(){
        let url = "\(APIInfo.url)query=\(searchTerm)"
        
        let header:HTTPHeaders = ["X-Naver-Client-Id": APIInfo.clientId, "X-Naver-Client-Secret": APIInfo.clientSecret]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: Shopping.self){ response in
            switch response.result{
            case .success(let value):
                self.searhResult = value
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout{
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionCellWidth = (UIScreen.main.bounds.width - ShoppingCell.spacingWidth * (ShoppingCell.cellColumns + 1)) / ShoppingCell.cellColumns
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        flowLayout.minimumLineSpacing = ShoppingCell.spacingWidth
        flowLayout.minimumInteritemSpacing = ShoppingCell.spacingWidth
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: ShoppingCell.spacingWidth, bottom: 0, right: ShoppingCell.spacingWidth)
        return flowLayout
    }

}


extension SearchResultViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let resultItems = searhResult?.items else { return 0 }
        return resultItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
        return cell
    }
    
    
}
