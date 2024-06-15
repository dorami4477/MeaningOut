//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/14/24.
//

import UIKit

class SettingViewController: UIViewController {
    
    let tableView = UITableView()
    
    let list = ["나의 장바구니 목록", "자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)], with: .none)
    }
    
    private func configureHierarchy(){
        view.addSubview(tableView)
    }
    private func configureLayout(){
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "SETTING"
    }
    
    private func configureTableView(){

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingFirstCell.self, forCellReuseIdentifier: SettingFirstCell.identifier)
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
    }


}

// MARK: - TableView
extension SettingViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
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
            let profileVC = ProfileNickNameViewController()
            navigationController?.pushViewController(profileVC, animated: true)
        }else if indexPath.row == 5{
            let alert = UIAlertController(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?", preferredStyle: .alert)
            
            let confirm = UIAlertAction(title: "확인", style: .default){ _ in
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
                
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let rootViewController = UINavigationController(rootViewController: OnboardingViewController())
                
                sceneDelegate?.window?.rootViewController = rootViewController
                sceneDelegate?.window?.makeKeyAndVisible()
                
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(cancel)
            alert.addAction(confirm)
            
            present(alert, animated: true)
        }
    }
    
}
