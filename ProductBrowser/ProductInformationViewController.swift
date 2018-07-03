//
//  ProductInformationViewController.swift
//  ProductBrowser
//
//  Created by Prajakta Kulkarni on 03/07/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import UIKit

class ProductInformationViewController: UIViewController {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    var product: Product!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.title = product.name
        initializeView()
    }
    func initializeView() {
        if let url = product.imageURL {
            self.productImageView.loadImageUsingCacheWithURLString(url,
                                                                   placeHolder: UIImage(named: "placeholder"))
        }
        self.navigationController?.title = product.name
        productTitleLabel.text =  product.name
        if (product.productDescription?.isHTML())! {
             productDescriptionTextView.text = product.productDescription?.htmlToString
        } else if !(product.productDescription?.isEmpty)! {
             productDescriptionTextView.text = product.productDescription
        } else {
            productDescriptionTextView.text =  "Product description not available"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
