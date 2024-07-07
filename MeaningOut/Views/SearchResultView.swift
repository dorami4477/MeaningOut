//
//  SearchResultView.swift
//  MeaningOut
//
//  Created by 박다현 on 6/26/24.
//

import UIKit

class SearchResultView: BaseView {
    
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
    
    let resultCountLabel = {
        let label = UILabel()
        label.textColor = AppColor.primary
        label.font = AppFont.size13Bold
        return label
    }()
    
    let filter01Button = FilterButton(title: FilterName.sim.rawValue)
    let filter02Button = FilterButton(title: FilterName.date.rawValue)
    let filter03Button = FilterButton(title: FilterName.dsc.rawValue)
    let filter04Button = FilterButton(title: FilterName.asc.rawValue)
    
    lazy var filterButtons:[FilterButton] = [filter01Button, filter02Button, filter03Button, filter04Button]
    
    lazy var filterStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.alignment = .leading
        return sv
    }()
    
    private lazy var filterCollectionSV = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy(){
        [resultCountLabel, emptyImg, emptyLebel, filterCollectionSV ].forEach { addSubview($0) }
        [filter01Button, filter02Button, filter03Button,filter04Button ].forEach { filterStackView.addArrangedSubview($0) }
        [filterStackView, collectionView ].forEach { filterCollectionSV.addArrangedSubview($0) }
    }
    
    override func configureLayout(){
        emptyImg.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalTo(snp.centerY)
            make.height.equalTo(emptyImg.snp.width).multipliedBy(0.75)
        }
        emptyLebel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(emptyImg.snp.bottom).offset(10)
        }
        
        resultCountLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        filterCollectionSV.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        filterStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(filterStackView.snp.bottom).offset(10)
        }
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
