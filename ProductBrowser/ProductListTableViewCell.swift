//
//  ProductListTableViewCell.swift
//  ProductBrowser
//
//  Created by Prajakta Kulkarni on 28/06/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func setProductCell(product: Product) {
        DispatchQueue.main.async {
            self.productTitleLabel.text = product.name
            print(product.imageURL ?? " ")
            if let url = product.imageURL {
                self.productImageView.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
            }
        }
    }

}
