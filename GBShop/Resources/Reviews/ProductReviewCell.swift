//
//  ProductReviewCell.swift
//  GBShop
//
//  Created by Maxim Safronov on 28.12.2020.
//

import UIKit

class ProductReviewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    // MARK: - Properties
    var cellDelegate: ReviewCellDelegate?
    
    override func prepareForReuse() {
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
    // MARK: - Methods
    func configureWith(review: Review) {
        lblDescription.text = review.description
        lblUserName.text = review.userFullName
    }
    // MARK: - Actions
    @IBAction func btnRemoveReviewClicked(_ sender: AnyObject) {
        cellDelegate?.didPressButton(self)
    }
}
