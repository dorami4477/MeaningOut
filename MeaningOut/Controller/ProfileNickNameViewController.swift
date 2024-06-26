//
//  ProfileNickNameViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit

enum NicknameValidationError:Error{
    case lengthOver10
    case specialLetters
    case integer
    case lengthUnder2
    
    var message:String{
        switch self {
        case .lengthOver10:
            return "2글자 이상 10글자 미만으로 설정해주세요."
        case .specialLetters:
            return "닉네임에 @, #, $, % 는 포함할 수 없어요."
        case .integer:
            return "닉네임에 숫자는 포함 할 수 없어요."
        case .lengthUnder2:
            return "2글자 이상 10글자 미만으로 설정해주세요."
        }

    }
}

final class ProfileNickNameViewController: BaseViewController{
        
    private let mainView = ProfileNickNameView()
    
    var profileImgName = ""
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setTapGesture()
        setProfileImg()
    }
    
    override func configureView(){
        navigationItem.title = "PROFILE SETTING"
        self.navigationController?.navigationBar.isHidden = false
        mainView.nicktextfield.delegate = self
    }
    
    //화면경로 다른 UI 분기처리
    private func configureUI(){
        if let nickName = UserDefaultsManager.nickName{
            //프로필수정으로 들어온 사용자
            mainView.nicktextfield.text = nickName
            mainView.doneButton.isHidden = true
            
            let save = UIBarButtonItem(title:"저장", style: .plain, target: self, action: #selector(doneButtonTapped(_:)))
            save.tintColor = AppColor.black
            let attributes: [NSAttributedString.Key : Any] = [ .font: AppFont.size16Bold ]
            save.setTitleTextAttributes(attributes, for: .normal)
            navigationItem.rightBarButtonItem = save
            
            mainView.warningLabel.textColor = AppColor.passGreen
            mainView.warningLabel.text = "사용할 수 있는 닉네임이에요."
            
        }else{
            //첫이용자
            mainView.doneButton.isHidden = false
        }
    }
    
    private func setProfileImg(){
        if profileImgName != ""{
            mainView.profileView.profileImageView.image = UIImage(named: profileImgName)
        }else{
            let randomNum = Int.random(in: 0...11)
            profileImgName = "profile_\(randomNum)"
            mainView.profileView.profileImageView.image = UIImage(named: profileImgName)
        }
    }
    
    //탭 제스쳐 세팅
    private func setTapGesture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped(_:)))
        mainView.profileView.addGestureRecognizer(tapGestureRecognizer)
        
        mainView.doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
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
        
        guard let text = mainView.nicktextfield.text else { return }
        UserDefaultsManager.nickName = text
        UserDefaultsManager.profileImage = profileImgName
        
        
        if let _ = sender as? UIBarButtonItem{
            //save버튼 클릭시
            navigationController?.popViewController(animated: true)
            
        }else{
            //Done 버튼 클릭시
            UserDefaultsManager.signUpDate = Date().formatted()
            changeRootVC(TabBarController())
        }
    }

}


// MARK: - UserDataDelegate
extension ProfileNickNameViewController:UserDataDelegate{
    func sendImageName(_ imageName:String) {
        profileImgName = imageName
        mainView.profileView.profileImageView.image = UIImage(named: profileImgName)
    }
}

// MARK: - TextFieldDelegate
extension ProfileNickNameViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        do {
            let result = try validateNickname(textField, range: range, string: string)
            mainView.warningLabel.text = "사용할 수 있는 닉네임이에요."
            mainView.warningLabel.textColor = AppColor.passGreen
            mainView.doneButton.backgroundColor = AppColor.primary
            mainView.activeButton()
            isActiveBarButton(true)
            return result
            
        } catch NicknameValidationError.lengthOver10 {
            mainView.setErrorUI(.lengthOver10)
            return false
            
        } catch NicknameValidationError.specialLetters {
            mainView.setErrorUI(.specialLetters)
            return false
            
        } catch NicknameValidationError.integer {
            mainView.setErrorUI(.integer)
            return false
            
        } catch NicknameValidationError.lengthUnder2 {
            mainView.setErrorUI(.lengthOver10)
            isActiveBarButton(false)
            return true
            
        } catch{
            return false
        }


    }
    
    
    private func validateNickname(_ textField: UITextField, range: NSRange, string: String) throws -> Bool{
        guard Int(string) == nil else{
            //숫자가 지워지고 사용가능한 닉네임인 경우
            if textField.text!.count >=  2 && textField.text!.count < 10{
                mainView.activeButton()
                isActiveBarButton(true)
            }
            throw NicknameValidationError.integer
        }
        
        //특수문자 확인
        if string == "@" || string == "#" || string == "$" || string == "%" {
            //특수문자가 지워지고 사용 가능한 닉네임인 경우
            if textField.text!.count >=  2 && textField.text!.count < 10{
                mainView.activeButton()
                isActiveBarButton(true)
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
                mainView.activeButton()
                isActiveBarButton(true)
            }
            throw NicknameValidationError.lengthOver10
        }
        
        //통과
        return true
    }
    

    
    private func isActiveBarButton(_ active:Bool){
        guard let barButton = navigationItem.rightBarButtonItem else { return }
        
        if active{
            barButton.isEnabled = true
            barButton.tintColor = AppColor.black
            let attributes: [NSAttributedString.Key : Any] = [ .font: AppFont.size16Bold ]
            barButton.setTitleTextAttributes(attributes, for: .normal)
            navigationItem.rightBarButtonItem = barButton
            
        }else{
            barButton.isEnabled = false
            barButton.tintColor = AppColor.gray02
            let attributes: [NSAttributedString.Key : Any] = [ .font: AppFont.size16 ]
            barButton.setTitleTextAttributes(attributes, for: .normal)
            navigationItem.rightBarButtonItem = barButton
        }
    }
    

}


