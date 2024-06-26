//
//  SearchView.swift
//  MeaningOut
//
//  Created by 박다현 on 6/26/24.
//

import UIKit

class SearchView: BaseView {

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

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout())

    
    override func configureHierarchy(){
        addSubview(emptyImg)
        addSubview(emptyLebel)
        addSubview(collectionView)
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
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
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
