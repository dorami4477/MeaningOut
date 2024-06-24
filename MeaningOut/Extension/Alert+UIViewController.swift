//
//  Alert+UiViewController.swift
//  MeaningOut
//
//  Created by 박다현 on 6/24/24.
//

import UIKit


extension UIViewController{
    
    func showAlert(title:String, message:String, buttonTilte:String, completionHandler:@escaping (UIAlertAction) -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: buttonTilte, style: .default, handler: completionHandler)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
