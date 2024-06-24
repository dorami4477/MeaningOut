//
//  ProfileNickNameViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit

final class ProfileNickNameViewController: UIViewController{
        
    var profileImgName = ""
    
    let profileView = ProfileView()
    
    let nicktextfield = {
        let tf = UITextField()
        tf.placeholder = "닉네임을 입력해주세요 :)"
        return tf
    }()
    private let warningLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    private let doneButton = PrimaryButton(title: "완료", active: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTextField()
        setTapGesture()
        setProfileImg()
        Basic.setting(self, title: "PROFILE SETTING")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let border = CALayer()
        border.frame = CGRect(x: 0, y: nicktextfield.frame.size.height + 8, width: nicktextfield.frame.width, height: 1)
        border.backgroundColor = AppColor.gray03.cgColor
        nicktextfield.layer.addSublayer(border)
        
    }
    
    
    private func configureHierarchy(){
        [profileView, nicktextfield, warningLabel, doneButton].forEach{ view.addSubview($0) }
    }
    
    private func configureLayout(){
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(view.snp.centerX)
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
    private func configureUI(){
        doneButton.isEnabled = false
        self.navigationController?.navigationBar.isHidden = false;
    }
    
    private func configureTextField(){
        nicktextfield.delegate = self
        if let nickName = UserDefaultsManager.nickName{
            
            nicktextfield.text = nickName
            doneButton.isHidden = true
            
            let save = UIBarButtonItem(title:"저장", style: .plain, target: self, action: #selector(doneButtonTapped(_:)))
            save.tintColor = AppColor.black
            let attributes: [NSAttributedString.Key : Any] = [ .font: UIFont.boldSystemFont(ofSize: 16) ]
            save.setTitleTextAttributes(attributes, for: .normal)
            navigationItem.rightBarButtonItem = save
            
            warningLabel.textColor = AppColor.passGreen
            warningLabel.text = "사용할 수 있는 닉네임이에요."
            
        }else{
            doneButton.isHidden = false
        }
    }
    
    private func setProfileImg(){
        if profileImgName != ""{
            profileView.profileImageView.image = UIImage(named: profileImgName)
        }else{
            let randomNum = Int.random(in: 0...11)
            profileImgName = "profile_\(randomNum)"
            profileView.profileImageView.image = UIImage(named: profileImgName)
        }
    }
    
    //탭 제스쳐 세팅
    private func setTapGesture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped(_:)))
        profileView.addGestureRecognizer(tapGestureRecognizer)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
    }
    
    //프로필 이미지 클릭 시
    @objc private func profileViewTapped(_ sender: UITapGestureRecognizer) {
        let profileVC = ProfileImageViewController()
        profileVC.profileView.profileImageView.image = UIImage(named: profileImgName)
        profileVC.selectedImg = profileImgName
        
        profileVC.delegate = self
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    //Done or Save 버튼 클릭 시
    @objc private func doneButtonTapped(_ sender: Any) {
        
        guard let text = nicktextfield.text else { return }
        UserDefaultsManager.nickName = text
        UserDefaultsManager.profileImage = profileImgName
        
        // save버튼 done버튼 분기
        if let _ = sender as? UIBarButtonItem{
                navigationController?.popViewController(animated: true)
            
        }else{
            
            UserDefaultsManager.signUpDate = Date().formatted()
            
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let rootViewController = TabBarController()
            
            
            sceneDelegate?.window?.rootViewController = rootViewController
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }

}


// MARK: - UserDataDelegate
extension ProfileNickNameViewController:UserDataDelegate{
    func sendImageName(_ imageName:String) {
        profileImgName = imageName
        profileView.profileImageView.image = UIImage(named: profileImgName)
    }
}

// MARK: - TextFieldDelegate
extension ProfileNickNameViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        do {
            let result = try validateNickname(textField, range: range, string: string)
            warningLabel.text = "사용할 수 있는 닉네임이에요."
            warningLabel.textColor = AppColor.passGreen
            doneButton.backgroundColor = AppColor.primary
            activeButton()
            return result
            
        } catch NicknameValidationError.lengthOver10 {
            setErrorUI(.lengthOver10)
            return false
            
        } catch NicknameValidationError.specialLetters {
            setErrorUI(.specialLetters)
            return false
            
        } catch NicknameValidationError.integer {
            setErrorUI(.integer)
            return false
            
        } catch NicknameValidationError.lengthUnder2 {
            setErrorUI(.lengthOver10)
            isActiveBarButton(false)
            return true
            
        } catch{
            return false
        }
        
        

    }
    
    
    func validateNickname(_ textField: UITextField, range: NSRange, string: String) throws -> Bool{
        guard Int(string) == nil else{
            //숫자가 지워지고 사용가능한 닉네임인 경우
            if textField.text!.count >=  2 && textField.text!.count < 10{
                activeButton()
            }
            throw NicknameValidationError.integer
        }
        
        //특수문자 확인
        if string == "@" || string == "#" || string == "$" || string == "%" {
            //특수문자가 지워지고 사용 가능한 닉네임인 경우
            if textField.text!.count >=  2 && textField.text!.count < 10{
                activeButton()
            }
            throw NicknameValidationError.specialLetters
        }
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        //2글자 미만
        if newLength < 2 {
            throw NicknameValidationError.lengthUnder2
        //10글자 이상
        }else if newLength >= 10 {
            //숫자가 지워지고 사용 가능한 닉네임인 경우
            if textField.text!.count < 10{
                activeButton()
            }
            throw NicknameValidationError.lengthOver10
        }
        
        //통과
        return true
    }
    
    private func activeButton(){
        doneButton.isEnabled = true
        doneButton.backgroundColor = AppColor.primary
        isActiveBarButton(true)
    }

    private func setErrorUI(_ error:NicknameValidationError){
        warningLabel.text = error.message
        warningLabel.textColor = AppColor.primary
        doneButton.backgroundColor = AppColor.primary
        doneButton.backgroundColor = AppColor.gray03

    }
    
    private func isActiveBarButton(_ active:Bool){
        guard let barButton = navigationItem.rightBarButtonItem else { return }
        
        if active{
            barButton.isEnabled = true
            barButton.tintColor = AppColor.black
            let attributes: [NSAttributedString.Key : Any] = [ .font: UIFont.boldSystemFont(ofSize: 16) ]
            barButton.setTitleTextAttributes(attributes, for: .normal)
            navigationItem.rightBarButtonItem = barButton
            
        }else{
            barButton.isEnabled = false
            barButton.tintColor = AppColor.gray02
            let attributes: [NSAttributedString.Key : Any] = [ .font: UIFont.systemFont(ofSize: 16) ]
            barButton.setTitleTextAttributes(attributes, for: .normal)
            navigationItem.rightBarButtonItem = barButton
        }
    }
    

}


