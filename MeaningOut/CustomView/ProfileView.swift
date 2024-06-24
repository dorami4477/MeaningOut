//
//  ProfileImageView.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit

class ProfileView:UIView{
    let profileImageView = {
        let imgView = UIImageView()
        imgView.layer.borderColor = AppColor.primary.cgColor
        imgView.layer.borderWidth = 4
        imgView.contentMode = .scaleAspectFit
        imgView.layer.cornerRadius = 50
        imgView.clipsToBounds = true
        return imgView
    }()
    let cameraView = {
       let view = UIView()
        view.backgroundColor = AppColor.primary
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    let cameraImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "camera.fill")
        img.tintColor = AppColor.white
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()

    }
    private func configureHierarchy(){
        [profileImageView, cameraView].forEach{ self.addSubview($0) }
        cameraView.addSubview(cameraImageView)
    }
    private func configureLayout(){
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cameraView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.height.equalTo(28)
        }
        cameraImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
