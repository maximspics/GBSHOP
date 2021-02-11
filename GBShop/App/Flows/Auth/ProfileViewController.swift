//
//  ProfileViewController.swift
//  GBShop
//
//  Created by Maxim Safronov on 15.12.2020.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtRepeatNewPassword: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet var profileLabels: [UILabel]!
    @IBOutlet var txtFields: [UITextField]!
    
    // MARK: - Properties
    var userFactory = RequestFactory().makeAuthRequestFactory()
  
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProfileInterface()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewClicked))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        if !isNeedLogin {
            loadProfile()
        } else {
            login(delegate: self)
            lblLogin.text = "Необходима авторизация"
            btnLogin.setTitle("Войти", for: .normal)
        }
    }
    
    // MARK: - Private Methods
    private func loadProfile() {
        if let userId = userId {
            userFactory.getUserBy(userId: userId) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case let .success(userData):
                    DispatchQueue.main.async {
                        self.willDisappear(bool: false)
                        self.txtEmail.text = userData.email
                        self.txtFirstName.text = userData.firstName
                        self.txtLastName.text = userData.lastName
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.willDisappear(bool: true)
                        self.showErrorMessage(message: "Невозможно загрузить данные")
                        self.lblLogin.text = "Невозможно загрузить данные"
                        self.btnLogin.setTitle("Выйти", for: .normal)
                    }
                }
            }
        } else {
            willDisappear(bool: true)
            showErrorMessage(message: "Невозможно загрузить данные")
            lblLogin.text = "Невозможно загрузить данные"
            btnLogin.setTitle("Выйти", for: .normal)
        }
    }
    
    private func toggleProfileInterface(hide: Bool = true) {
        for lbl in profileLabels {
            lbl.isHidden = hide
        }
        for txtfield in txtFields {
            txtfield.isHidden = hide
        }
        btnSave.isHidden = hide
        btnLogout.isHidden = hide
        lblLogin.isHidden = !hide
        btnLogin.isHidden = !hide
    }
    
    private func showProfileInterface(hide: Bool = true) {
        if !isNeedLogin {
            willDisappear(bool: false)
        } else {
            willDisappear(bool: true)
        }
    }
    
    // MARK: - Methods
    @objc func viewClicked() {
        view.endEditing(true)
    }
    
    func logout() {
        if let uID = userId {
            userFactory.logout(userId: uID) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.showLogoutMessage(message: "Вы уверены, что хотите выйти?")
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.showErrorMessage(message: "При попытке выхода произошла ошибка")
                    }
                }
            }
        } else {
            showErrorMessage(message: "При попытке выхода произошла ошибка")
        }
        lblLogin.text = "Необходима авторизация"
        btnLogin.setTitle("Войти", for: .normal)
    }
    
    func showLogoutMessage(message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertVC = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Выйти", style: .default) { _ in
            self.appService.session.killUserInfo()
            self.showProfileInterface()
        }
        let noAction = UIAlertAction(title: "Отмена", style: .default, handler: handler)
        
        alertVC.addAction(okAction)
        alertVC.addAction(noAction)
        present(alertVC, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func btnLogin(_ sender: Any) {
        if !isNeedLogin {
            logout()
        } else {
            login(delegate: self)
        }
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        logout()
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        guard let userId = userId else {
            return
        }
        
        guard let email = txtEmail.text, !email.isEmpty else {
            return showErrorMessage(message: "Введите email")
        }
        
        let spletedWithSymbolAt = email.split(separator: "@", maxSplits: 1)
        
        let beforeSymbolAt = String(spletedWithSymbolAt.first ?? " ")
        let afterSymbolAt = String(spletedWithSymbolAt.last ?? " ")
        
        let splitedWithSymbolDot = afterSymbolAt.split(separator: ".", maxSplits: 1)
        
        let beforeSymbolDot = String(splitedWithSymbolDot.first ?? " ")
        let afterSymbolDot = String(splitedWithSymbolDot.last ?? " ")
        
        guard spletedWithSymbolAt.count == 2, splitedWithSymbolDot.count == 2,
              beforeSymbolAt.count >= 1,
              beforeSymbolDot.count >= 1,
              afterSymbolDot.count >= 2 else {
            return showErrorMessage(message: "Введен некорректный email")
        }
        
        guard let password = txtOldPassword.text, !password.isEmpty else {
            return showErrorMessage(message: "Введите пароль, чтобы внести изменения")
        }
        
        let newPassword = txtNewPassword.text
        let repeatPassword = txtRepeatNewPassword.text
        
        guard newPassword == repeatPassword else {
            return showErrorMessage(message: "Пароли должны совпадать")
        }
        
        guard password != newPassword else {
            return showErrorMessage(message: "Новый пароль должен отличаться от старого")
        }
        
        guard let firstName = txtFirstName.text, !firstName.isEmpty else {
            return showErrorMessage(message: "Введите имя")
        }
        
        let user = User(id: userId,
                        email: email,
                        password: password,
                        newPassword: newPassword,
                        firstName: firstName,
                        lastName: txtLastName.text)
        
        userFactory.changeUserDataTo(user: user) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case let .success(changeData):
                DispatchQueue.main.async {
                    switch changeData {
                    case (_ ) where changeData.result == 1:
                        self.showErrorMessage(message: changeData.userMessage, title: "Успешно")
                    case (_ ) where changeData.result == 0:
                        self.showErrorMessage(message: changeData.userMessage, title: "Упс")
                    default:
                        self.showErrorMessage(message: changeData.userMessage, title: "Ошибка")
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showErrorMessage(message: "Невозможно сохранить изменения")
                }
            }
        }
    }
}

extension ProfileViewController: NeedLoginDelegate {
    func willReloadData() {
        loadProfile()
    }
    
    func willDisappear(bool: Bool) {
        toggleProfileInterface(hide: bool)
    }
    
}
