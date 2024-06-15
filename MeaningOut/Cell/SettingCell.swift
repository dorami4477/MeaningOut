//
//  SettingCell.swift
//  MeaningOut
//
//  Created by 박다현 on 6/15/24.
//

import UIKit

class SettingCell: UITableViewCell {

    let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    let iconImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: IconName.bagFill)
        img.tintColor = AppColor.gray01
        return img
    }()
    
    let favNumLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = UserDefaultsManager.favorite.count.formatted() + "개의 상품"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
    }
    
    
    private func configureHierarchy(){
        [titleLabel, favNumLabel, iconImageView].forEach { contentView.addSubview($0)}
       
    }
    private func configureLayout(){
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(15)
        }
        favNumLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(15)
        }
        iconImageView.snp.makeConstraints { make in
            make.trailing.equalTo(favNumLabel.snp.leading).offset(-4)
            make.verticalEdges.equalToSuperview().inset(15)
        }

    }
    
    func hiddenFavorite(){
        favNumLabel.isHidden = true
        iconImageView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
