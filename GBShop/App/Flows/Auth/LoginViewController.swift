//
//  LoginViewController.swift
//  GBShop
//
//  Created by Maxim Safronov on 15.12.2020.
//

import UIKit

class LoginViewController: BaseViewController {
    // MARK: Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var scrollContainer: UIScrollView!
    
    // MARK: - Properties
    let userFactory = RequestFactory().makeAuthRequestFactory()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewClicked(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Methods
    @objc func viewClicked(_ sender: UIView) {
        view.endEditing(true)
        scrollViewReset()
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        
        guard let info = notification.userInfo as NSDictionary?,
              let kbSizeInfo = info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return
        }
        
        let kbSize = kbSizeInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        
        scrollContainer.contentInset = contentInsets
        scrollContainer.scrollIndicatorInsets = contentInsets
        scrollContainer.contentOffset = CGPoint(x: 0, y: kbSize.height)
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        scrollViewReset()
    }
    
    fileprivate func scrollViewReset() {
        scrollContainer.contentInset = UIEdgeInsets.zero
        scrollContainer.scrollIndicatorInsets = UIEdgeInsets.zero
        scrollContainer.contentOffset = CGPoint.zero
    }
    
    // MARK: - Actions
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        guard let email = txtEmail.text, let password = txtPassword.text,
              !email.isEmpty, !password.isEmpty else {
            self.showErrorMessage(message: "Необходимо ввести email и пароль")
            return
        }
        
        userFactory.loginWith(email: email, password: password) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let login):
                DispatchQueue.main.async {
                    self.appService.session.setUserInfo(login.user!)
                    self.needLoginDelegate?.willReloadData()
                    self.needLoginDelegate?.willDisappear(bool: false)
                    self.dismiss(animated: true)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showErrorMessage(message: "При попытке входа произошлка ошибка")
                }
            }
        }
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        dismiss(animated: true)
        self.needLoginDelegate?.willDisappear(bool: true)
    }
    
    @IBAction func btnRegisterClicked(_ sender: Any) {
        guard let registerVC = AppService.shared.getScreenPage(identifier: "registerScreen") as? RegisterViewController else { return }
        registerVC.fillLoginScreenDelegate = self
        txtEmail.text = nil
        txtPassword.text = nil
        registerVC.modalPresentationStyle = .overFullScreen
        present(registerVC, animated: true)
    }
}

extension LoginViewController: FillLoginScreenDelegate {
    func fillLoginScreenWith(email: String?, password: String?) {
        txtEmail.text = email
        txtPassword.text = password
    }
}
