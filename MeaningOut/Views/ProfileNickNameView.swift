//
//  ProfileNickNameView.swift
//  MeaningOut
//
//  Created by 박다현 on 6/26/24.
//

import UIKit

class ProfileNickNameView: BaseView {

    let profileView = ProfileView()
    
    let nicktextfield = {
        let tf = UITextField()
        tf.placeholder = "닉네임을 입력해주세요 :)"
        return tf
    }()
    let warningLabel = {
        let label = UILabel()
        label.font = AppFont.size13
        return label
    }()
    let doneButton = PrimaryButton(title: "완료", active: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doneButton.isEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let border = CALayer()
        border.frame = CGRect(x: 0, y: nicktextfield.frame.size.height + 8, width: nicktextfield.frame.width, height: 1)
        border.backgroundColor = AppColor.gray03.cgColor
        nicktextfield.layer.addSublayer(border)
    }
    
    override func configureHierarchy(){
        [profileView, nicktextfield, warningLabel, doneButton].forEach{ addSubview($0) }
    }
    
    override func configureLayout(){
        profileView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(snp.centerX)
            make.width.height.equalTo(100)
        }
        nicktextfield.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(nicktextfield.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(warningLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    func activeButton(){
        doneButton.isEnabled = true
        doneButton.backgroundColor = AppColor.primary
        
    }

    func setErrorUI(_ error:NicknameValidationError){
        warningLabel.text = error.message
        warningLabel.textColor = AppColor.primary
        doneButton.backgroundColor = AppColor.primary
        doneButton.backgroundColor = AppColor.gray03
    }
}
