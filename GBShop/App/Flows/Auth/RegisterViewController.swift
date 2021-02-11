//
//  RegisterViewController.swift
//  GBShop
//
//  Created by Maxim Safronov on 15.12.2020.
//

import UIKit

class RegisterViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    // MARK: - Properties
    let userFactory = RequestFactory().makeAuthRequestFactory()
    var userLogin: String?
    var userPassword: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Регистрация"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewClicked))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Methods
    @objc private func viewClicked() {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction func btnRegisterClicked(_ sender: Any) {
        guard let email = txtEmail.text, !email.isEmpty else {
            return showErrorMessage(message: "Введите email", title: "Ошибка!")
        }
        
        guard isValidEmail(email) else {
            return showErrorMessage(message: "Введен некорректный email", title: "Ошибка!")
        }
        
        guard let password = txtPassword.text, !password.isEmpty else {
            return showErrorMessage(message: "Введите пароль", title: "Ошибка!")
        }
        guard let repeatPassword = txtNewPassword.text, !repeatPassword.isEmpty else {
            return showErrorMessage(message: "Повторите пароль", title: "Ошибка!")
        }
        guard password == repeatPassword else {
            return showErrorMessage(message: "Пароли должны совпадать", title: "Ошибка!")
        }
        guard let firstName = txtFirstName.text, !firstName.isEmpty else {
            return showErrorMessage(message: "Введите имя", title: "Ошибка!")
        }
        
        let newUser = User(id: nil,
                           email: email,
                           password: password,
                           newPassword: nil,
                           firstName: firstName,
                           lastName: txtLastName.text
        )
        
        userFactory.register(user: newUser) { response in
            switch response.result {
            case let .success(registerResult):
                DispatchQueue.main.async {
                    switch registerResult {
                    case (_ ) where registerResult.result == 1:
                        self.fillLoginScreenDelegate?.fillLoginScreenWith(email: self.txtEmail.text, password: self.txtPassword.text)
                        self.showErrorMessage(message: registerResult.userMessage, title: "Успешно!") { [weak self] _ in
                            guard let self = self else {
                                return
                            }
                            self.dismiss(animated: true)
                        }
                    default:
                        self.showErrorMessage(message: registerResult.userMessage, title: "Ошибка!")
                    }
                    
                }
            case .failure(_):
                self.showErrorMessage(message: "Ошибка регистрации")
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        dismiss(animated: true)
        self.needLoginDelegate?.willDisappear(bool: true)
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

