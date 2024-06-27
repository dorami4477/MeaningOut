//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/14/24.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    private let tableView = UITableView()
    
    private let list = ["나의 장바구니 목록", "자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)], with: .none)
    }
    
    func configureHierarchy(){
        view.addSubview(tableView)
    }
    func configureLayout(){
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    override func configureView(){
        navigationItem.title = "SETTING"
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingFirstCell.self, forCellReuseIdentifier: SettingFirstCell.identifier)
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }


}

// MARK: - TableView
extension SettingViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 140
        }
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            //프로필 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingFirstCell.identifier, for: indexPath) as! SettingFirstCell
            cell.selectionStyle = .none
            return cell
            
        }else{

            let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
            cell.selectionStyle = .none
            cell.titleLabel.text = list[indexPath.row - 1]
            if indexPath.row != 1{
                cell.hiddenFavorite()
            }else{
                cell.favoriteCounts()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
        //프로필 셀 클릭시
            let profileVC = ProfileNickNameViewController()
            
            profileVC.profileImgName = UserDefaultsManager.profileImage ?? ""
            navigationController?.pushViewController(profileVC, animated: true)
            
        }else if indexPath.row == 1{
        //장바구니 목록 셀 클릭시
            let basketList = BasketListViewController()
            navigationController?.pushViewController(basketList, animated: true)
            
        }else if indexPath.row == 5{
         //탈퇴하기 셀 클릭시
            showAlert(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?", buttonTilte: "탈퇴") { _ in
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
                let rootViewController = UINavigationController(rootViewController: OnboardingViewController())
                self.changeRootVC(rootViewController)
            }
            
        }
    }
    
}
