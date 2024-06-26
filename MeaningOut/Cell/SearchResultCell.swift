//
//  SearchResultCell.swift
//  MeaningOut
//
//  Created by 박다현 on 6/15/24.
//

import UIKit
import Kingfisher

final class SearchResultCell: UICollectionViewCell {
    
    var data:Item?{
        didSet{
            configureData()
            setFavoriteUI()
        }
    }

    var favorite = false
    
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
        label.font = AppFont.size13
        label.textColor = AppColor.gray03
        return label
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.font = AppFont.size14
        label.numberOfLines = 2
        return label
    }()
    
    let priceLabel = {
        let label = UILabel()
        label.font = AppFont.size16Bold
        return label
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        buttonAction()
        setSkeletion()
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
        }
        
    }
    private func buttonAction(){
        favoritesButton.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
    }
    
    private func setSkeletion(){
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        mainImageView.isSkeletonable = true
        favoritesButton.isSkeletonable = true
        mallNameLabel.isSkeletonable = true
        titleLabel.isSkeletonable = true
        priceLabel.isSkeletonable = true
    }
    
    private func configureData(){
        guard let data else { return }
        let url = URL(string: data.image)
        mainImageView.kf.setImage(with: url)
        titleLabel.text = data.titleBoldTag
        mallNameLabel.text = data.mallName
        priceLabel.text = data.price
        
    }
    
    @objc private func favButtonTapped(){
        favorite.toggle()
        setFavoriteUI()
        guard let data else { return }
        UserDefaultsManager.favorite[data.productId] = favorite
    }
    
    private func setFavoriteUI(){
        if favorite{
            favoritesButton.backgroundColor = AppColor.white
            favoritesButton.setImage(UIImage(named: IconName.bagFill), for: .normal)
            favoritesButton.tintColor = AppColor.gray01
        }else{
            
            favoritesButton.backgroundColor = AppColor.gray01.withAlphaComponent(0.5)
            favoritesButton.setImage(UIImage(named: IconName.bag), for: .normal)
            favoritesButton.tintColor = AppColor.white
        }
    }
    
    //검색한 텍스트스타일 변경
    func changeText(text:String){
        
        guard let mallText = mallNameLabel.text else { return }
        let attributedStr = NSMutableAttributedString(string: mallText)
        attributedStr.addAttribute(.backgroundColor, value: UIColor.yellow, range: (mallText.lowercased() as NSString).range(of: text.lowercased()))
        attributedStr.addAttribute(.foregroundColor, value: UIColor.black, range: (mallText.lowercased() as NSString).range(of: text.lowercased()))
        attributedStr.addAttribute(.font, value: AppFont.size13Bold, range: (mallText.lowercased() as NSString).range(of: text.lowercased()))
        mallNameLabel.attributedText = attributedStr
        
        guard let titleText = titleLabel.text else { return }
        let attributedStr2 = NSMutableAttributedString(string: titleText)
        attributedStr2.addAttribute(.backgroundColor, value: UIColor.yellow, range: (titleText.lowercased() as NSString).range(of: text.lowercased()))
        attributedStr2.addAttribute(.foregroundColor, value: UIColor.black, range: (titleText.lowercased() as NSString).range(of: text.lowercased()))
        attributedStr2.addAttribute(.font, value: AppFont.size14Bold, range: (titleText.lowercased() as NSString).range(of: text.lowercased()))
        titleLabel.attributedText = attributedStr2
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
