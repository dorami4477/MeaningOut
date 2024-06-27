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
    
    let headerView = UIView()

    private let titleLabel = {
        let label = UILabel()
        label.font = AppFont.size15Bold
        label.text = "최근 검색"
        return label
    }()

    let deleteButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(AppColor.white, for: .normal)
        button.backgroundColor = AppColor.black
        button.titleLabel?.font = AppFont.size13
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout())
    
    override func configureHierarchy(){
        addSubview(emptyImg)
        addSubview(emptyLebel)
        addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(deleteButton)
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
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalTo(headerView.snp.centerY)
        }
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(headerView.snp.centerY)
            make.width.equalTo(60)
        }
        collectionView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(headerView.snp.bottom)
            
        }
    }
    
    func flowLayout() -> UICollectionViewLayout{
        let layout = LeftAlignedCollectionViewFlowLayout()
        //let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        return layout
    }
}
