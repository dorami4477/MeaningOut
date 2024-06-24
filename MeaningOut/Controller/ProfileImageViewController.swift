//
//  ProfileImageViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit
import SnapKit

protocol UserDataDelegate:AnyObject {
    func sendImageName(_ imageName: String)
}

final class ProfileImageViewController: UIViewController {

    let profileView = ProfileView()
    
    private lazy var profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    private let profileImgNames = ["profile_0", "profile_1", "profile_2", "profile_3", "profile_4", "profile_5", "profile_6","profile_7", "profile_8", "profile_9", "profile_10", "profile_11"]
    
    var selectedImg = ""
    
    weak var delegate:UserDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        setCollectionView()
        Basic.setting(self, title: "PROFILE SETTING")
        self.navigationController?.navigationBar.isHidden = false;
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.delegate?.sendImageName(selectedImg)
    }
    
    private func configureHierarchy(){
        view.addSubview(profileView)
        view.addSubview(profileCollectionView)
    }
    private func configureLayout(){
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(100)
        }
        profileCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }


    private func collectionViewLayout() -> UICollectionViewLayout{
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionCellWidth = (UIScreen.main.bounds.width - ProfileCell.spacingWidth * (ProfileCell.cellColumns + 1)) / ProfileCell.cellColumns
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        flowLayout.minimumLineSpacing = ProfileCell.spacingWidth
        flowLayout.minimumInteritemSpacing = ProfileCell.spacingWidth
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: ProfileCell.spacingWidth, bottom: 0, right: ProfileCell.spacingWidth)
        return flowLayout
    }

    private func setCollectionView(){
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.register(ProfileImageCell.self, forCellWithReuseIdentifier: ProfileImageCell.identifier)
    }
}


// MARK: - collectionView
extension ProfileImageViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImgNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCell.identifier, for: indexPath) as! ProfileImageCell
        if selectedImg == profileImgNames[indexPath.row]{
            cell.isSelected(true)
        }
        
        cell.mainImageView.image = UIImage(named: profileImgNames[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.visibleCells.forEach { item in
            guard let cell = item as? ProfileImageCell else { return }
            cell.isSelected(false)
        }
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? ProfileImageCell else { return }
        selectedImg = profileImgNames[indexPath.row]
        selectedCell.isSelected(true)
        profileView.profileImageView.image = selectedCell.mainImageView.image

    }
    
}
