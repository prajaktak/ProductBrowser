//
//  ViewController.swift
//  ProductBrowser
//
//  Created by Prajakta Kulkarni on 27/06/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import UIKit

class ProductListingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var productsTableView: UITableView!
    var productsArray : [Product]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // swiftlint:disable line_length
        WebserviceManager().getData(form: "https://gist.githubusercontent.com/anonymous/a3b3e50413fff111505a/raw/0522419f508e7ea506a8856586dce11a5664e9df/products.json") { (result) in
            switch result{
            case .success(let jsonObject):
                CoreDataManager.sharedInstance.saveInCoreDataWith(array: jsonObject)
                print("Success")
            case .failure:
                print("Failure")
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - TableView delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productsArray != nil {
            return productsArray.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast line_length
        let productCell: ProductListTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductListTableViewCell
        // swiftlint:enable force_cast line_length
        productCell.imageView?.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        productCell.productTitleLabel.text = "Title"
        return productCell
    }

}
