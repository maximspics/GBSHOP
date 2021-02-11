//
//  AddReviewController.swift
//  GBShop
//
//  Created by Maxim Safronov on 29.12.2020.
//

import UIKit

class AddReviewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var txtReviewTitle: UILabel!
    @IBOutlet weak var txtReview: UITextView!
    
    // MARK: - Properties
    let reviewFabric = RequestFactory().makeReviewsRequestFactory()
    var product: ProductResult? {
        return appService.session.productInfo
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = product {
            txtReviewTitle.text = "Написать отзыв: " + product.name
        }
        txtReview.layer.borderWidth = 0.5
        txtReview.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        txtReview.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    @IBAction func btnCancelClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        guard let fullName = appService.session.userInfo?.fullName, !fullName.isEmpty,
              let email = appService.session.userInfo?.email, !email.isEmpty,
              let pID = productId else { return }
        
        guard let title = txtReviewTitle.text, !title.isEmpty else{
            return showErrorMessage(message: "Напишите заголовок отзыва!")
        }
        
        guard let reviewText = txtReview.text, !reviewText.isEmpty else {
            return showErrorMessage(message: "Напишите текст отзыва!")
        }
        
        let review = Review(id: nil,
                            productId: pID,
                            userFullName: fullName,
                            userEmail: email,
                            title: title,
                            description: reviewText)
        
        reviewFabric.addReviewForProductBy(productId: pID, review: review) { [weak self] response in
            guard let self = self else {
                return
            }
            
            switch response.result {
            case .success(_):
                DispatchQueue.main.async {
                    self.needLoginDelegate?.willReloadData()
                    self.showErrorMessage(message: "Отзыв добавлен!", title: "Успешно") {_ in
                        self.dismiss(animated: true)
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showErrorMessage(message: "Добавить отзыв не получилось")
                }
            }
        }
    }
}

