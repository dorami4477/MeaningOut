//
//  ProfileNickNameViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit

class ProfileNickNameViewController: UIViewController {
    
    var profileImgName = ""
    
    let profileView = UIView()
    lazy var profileImageView = ProfileImageView()
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
    let nicktextfield = {
        let tf = UITextField()
        tf.placeholder = "닉네임을 입력해주세요 :)"
        return tf
    }()
    let warningLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    let doneButton = PrimaryButton(title: "완료", active: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTextField()
        setTapGesture()
        setProfileImg()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let border = CALayer()
        border.frame = CGRect(x: 0, y: nicktextfield.frame.size.height + 8, width: nicktextfield.frame.width, height: 1)
        border.backgroundColor = AppColor.gray03.cgColor
        nicktextfield.layer.addSublayer(border)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfileImg()
    }
    
    private func configureHierarchy(){
        [profileView, nicktextfield, warningLabel, doneButton].forEach{ view.addSubview($0) }
        [profileImageView, cameraImageView].forEach{ profileView.addSubview($0) }
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
        nicktextfield.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
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
        view.backgroundColor = .white
        title = "PROFILE SETTING"
        doneButton.isEnabled = false
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
            
            warningLabel.textColor = NicknameValidation.pass.messageColor
            warningLabel.text = NicknameValidation.pass.rawValue
            
        }else{
            doneButton.isHidden = false
        }
    }
    
    func setProfileImg(){
        if let name = UserDefaultsManager.profileImage{
            profileImgName = name
            profileImageView.image = UIImage(named: name)
            
        }else{
            let randomNum = Int.random(in: 0...11)
            profileImgName = "profile_\(randomNum)"
            profileImageView.image = UIImage(named: profileImgName)
            UserDefaultsManager.profileImage = profileImgName
        }
    }
    
    private func setTapGesture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped(_:)))
        profileView.addGestureRecognizer(tapGestureRecognizer)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
    }
    
    //프로필 이미지 클릭 시
    @objc func profileViewTapped(_ sender: UITapGestureRecognizer) {        
        let profileVC = ProfileImageViewController()
        profileVC.profileImageView.image = UIImage(named: profileImgName)
        profileVC.selectedImg = profileImgName
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    //완료 버튼 클릭 시
    @objc func doneButtonTapped(_ sender: Any) {
        
        guard let text = nicktextfield.text else { return }
        UserDefaultsManager.nickName = text
        
        
        // save버튼 done 버튼 분기
        if let _ = sender as? UIBarButtonItem{
            if warningLabel.text == NicknameValidation.pass.rawValue{
                navigationController?.popViewController(animated: true)
            }
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

// MARK: - TextFieldDelegate
extension ProfileNickNameViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //숫자확인
        guard Int(string) == nil else{
            warningLabel.text = NicknameValidation.integer.rawValue
            warningLabel.textColor = NicknameValidation.integer.messageColor
            doneButton.backgroundColor = AppColor.gray03
            isActiveBarButton(false)
            
            //숫자가 지워지고 사용가능한 닉네임인 경우
            if textField.text!.count >=  2 && textField.text!.count < 10{
                doneButton.isEnabled = true
                doneButton.backgroundColor = AppColor.primary
                isActiveBarButton(true)
            }
            return false
        }
        
        //특수문자 확인
        if string == "@" || string == "#" || string == "$" || string == "%" {
            warningLabel.text = NicknameValidation.specialLetters.rawValue
            warningLabel.textColor = NicknameValidation.specialLetters.messageColor
            doneButton.backgroundColor = AppColor.gray03
            isActiveBarButton(false)
            
            //숫자가 지워지고 사용 가능한 닉네임인 경우
            if textField.text!.count >=  2 && textField.text!.count < 10{
                doneButton.isEnabled = true
                doneButton.backgroundColor = AppColor.primary
                isActiveBarButton(true)
            }
            return false
        }
        
        //글자의 길이 확인
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
            //2글자 미만  //** 한글일 경우 문제
        if newLength < 2 {
            warningLabel.text = NicknameValidation.length.rawValue
            warningLabel.textColor = NicknameValidation.length.messageColor
            doneButton.backgroundColor = AppColor.gray03
            isActiveBarButton(false)
            return true
            //10글자 이상
        }else if newLength >= 10 {
            warningLabel.text = NicknameValidation.length.rawValue
            warningLabel.textColor = NicknameValidation.length.messageColor
            doneButton.backgroundColor = AppColor.gray03
            isActiveBarButton(false)
            
            //숫자가 지워지고 사용 가능한 닉네임인 경우
            if textField.text!.count < 10{
                doneButton.isEnabled = true
                doneButton.backgroundColor = AppColor.primary
                isActiveBarButton(true)
            }
            return false
        }

        
        //전부 통과
        warningLabel.text = NicknameValidation.pass.rawValue
        warningLabel.textColor = NicknameValidation.pass.messageColor
        doneButton.isEnabled = true
        doneButton.backgroundColor = AppColor.primary
        isActiveBarButton(true)
        return true
        
    }
    
    
    func isActiveBarButton(_ active:Bool){
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
