//
//  ProfileImageViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit
import SnapKit

class ProfileImageViewController: UIViewController {

    let profileView = UIView()
    let profileImageView = ProfileImageView()
    let cameraImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "camera.fill")
        img.backgroundColor = AppColor.primary
        img.tintColor = AppColor.white
        img.layer.cornerRadius = 15
        img.clipsToBounds = true
        img.contentMode = .center
        return img
    }()
    
    lazy var profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    let profileImgName = ["profile_0", "profile_1", "profile_2", "profile_3", "profile_4", "profile_5", "profile_6","profile_7", "profile_8", "profile_9", "profile_10", "profile_11"]
    
    var selectedImg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        setCollectionView()
    }
    private func configureHierarchy(){
        view.addSubview(profileView)
        [profileImageView, cameraImageView].forEach{ profileView.addSubview($0) }
        view.addSubview(profileCollectionView)
    }
    private func configureLayout(){
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(100)
        }
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cameraImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.height.equalTo(30)
        }

        profileCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    private func configureUI(){
        view.backgroundColor = .white
        title = "PROFILE SETTING"

    }

    private func collectionViewLayout() -> UICollectionViewLayout{
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionCellWidth = (UIScreen.main.bounds.width - CVCell.spacingWidth * (CVCell.cellColumns + 1)) / CVCell.cellColumns
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        flowLayout.minimumLineSpacing = CVCell.spacingWidth
        flowLayout.minimumInteritemSpacing = CVCell.spacingWidth
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: CVCell.spacingWidth, bottom: 0, right: CVCell.spacingWidth)
        return flowLayout
    }

    private func setCollectionView(){
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.register(ProfileImageCell.self, forCellWithReuseIdentifier: ProfileImageCell.identifier)
    }
}

extension ProfileImageViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImgName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCell.identifier, for: indexPath) as! ProfileImageCell
        if selectedImg == profileImgName[indexPath.row]{
            cell.isSelected(true)
        }
        
        cell.mainImageView.image = UIImage(named: profileImgName[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.visibleCells.forEach { item in
            guard let cell = item as? ProfileImageCell else { return }
            cell.isSelected(false)
        }
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? ProfileImageCell else { return }
        selectedCell.isSelected(true)
        profileImageView.image = selectedCell.mainImageView.image

        UserDefaultsManager.profileImage = profileImgName[indexPath.row]
    }
    
}
