//
//  SettingHeaderCell.swift
//  MeaningOut
//
//  Created by 박다현 on 6/15/24.
//

import UIKit

class SettingFirstCell: UITableViewCell {

    let profileView = UIView()
    
    let mainImageView = {
        let imgView = UIImageView()
        imgView.layer.borderColor = AppColor.primary.cgColor
        imgView.layer.borderWidth = 3
        imgView.image = UIImage(named: UserDefaultsManager.profileImage!)
        imgView.contentMode = .scaleAspectFit
        imgView.layer.cornerRadius = 40
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let nickNameLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.text = UserDefaultsManager.nickName
        return label
    }()
    
    let signupDateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = AppColor.gray02
        label.text = UserDefaultsManager.signUpDate
        return label
    }()
    
    let iconImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "chevron.right")
        img.tintColor = AppColor.gray02
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
    }
    
    override func prepareForReuse() {
        mainImageView.image = UIImage(named: UserDefaultsManager.profileImage!)
        nickNameLabel.text = UserDefaultsManager.nickName
    }
    
    private func configureHierarchy(){
        contentView.addSubview(profileView)
        [mainImageView, nickNameLabel, signupDateLabel, iconImageView].forEach { profileView.addSubview($0)}
       
    }
    private func configureLayout(){
        profileView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        mainImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(30)
            make.leading.equalToSuperview()
            make.width.height.equalTo(80)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(mainImageView.snp.trailing).offset(30)
            make.top.equalTo(iconImageView.snp.top).offset(-10)
        }
        signupDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(mainImageView.snp.trailing).offset(30)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(4)
        }
        iconImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
