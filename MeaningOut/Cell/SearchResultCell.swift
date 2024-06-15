//
//  SearchResultCell.swift
//  MeaningOut
//
//  Created by 박다현 on 6/15/24.
//

import UIKit
import Kingfisher

class SearchResultCell: UICollectionViewCell {
    
    var data:Item?{
        didSet{
            configureData()
            favorite = UserDefaultsManager.favorite
            setFavoriteUI()
        }
    }

    var favorite:[String:Bool] = [:]
    
    
    let mainImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 10
        img.clipsToBounds = true
        return img
    }()
    
    let favoritesButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bag.badge.plus"), for: .normal)
        button.tintColor = AppColor.white
        button.backgroundColor = AppColor.gray02.withAlphaComponent(0.5)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    let mallNameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = AppColor.gray03
        return label
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    let priceLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
        
        
    }


    private func configureHierarchy(){
        [mainImageView, favoritesButton, mallNameLabel, titleLabel, priceLabel].forEach { contentView.addSubview($0) }
    }
    private func configureLayout(){
        mainImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(mainImageView.snp.width).multipliedBy(1.2)
        }
        favoritesButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(mainImageView).inset(10)
            make.width.height.equalTo(35)
        }
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(4)
            make.leading.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.bottom.greaterThanOrEqualToSuperview().inset(12)
        }
        
    }
    private func configureUI(){
        favoritesButton.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
    }
    
    
    func configureData(){
        guard let data else { return }
        let url = URL(string: data.image)
        mainImageView.kf.setImage(with: url)
        titleLabel.text = data.title
        mallNameLabel.text = data.mallName
        priceLabel.text = data.price
    }
    
    @objc func favButtonTapped(){
        if var fav = favorite[data!.productId]{
            fav.toggle()
            favorite[data!.productId] = fav

        }else{
            favorite[data!.productId] = true
        }
        setFavoriteUI()
        
        UserDefaultsManager.favorite = favorite
    }
    
    func setFavoriteUI(){
        guard let data else { return }
        if let favData = favorite[data.productId], favData{
            
            favoritesButton.backgroundColor = AppColor.white
            favoritesButton.setImage(UIImage(systemName: "bag.fill.badge.minus"), for: .normal)
            favoritesButton.tintColor = AppColor.gray01
        }else{
            
            favoritesButton.backgroundColor = AppColor.gray01.withAlphaComponent(0.5)
            favoritesButton.setImage(UIImage(systemName: "bag.badge.plus"), for: .normal)
            favoritesButton.tintColor = AppColor.white
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
