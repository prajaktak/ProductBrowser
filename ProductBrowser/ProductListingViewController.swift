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
    var productsArray: [Product] = [Product]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // swiftlint:disable line_length
        initiateProductArray()
        WebserviceManager().getData(form: "https://gist.githubusercontent.com/anonymous/a3b3e50413fff111505a/raw/0522419f508e7ea506a8856586dce11a5664e9df/products.json") { (result) in
            switch result {
            case .success(let jsonObject):
                CoreDataManager.sharedInstance.saveInCoreDataWith(array: jsonObject)
                self.initiateProductArray()
                self.productsTableView.reloadData()
                print("Success")
            case .failure:
                print("Failure")
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    func initiateProductArray() {
        do {
            self.productsArray = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(Product.fetchRequest()) as [Product]
        } catch {
            print("can not fetch data for product")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - TableView delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast line_length
        let productCell: ProductListTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductListTableViewCell
        // swiftlint:enable force_cast line_length
        productCell.setProductCell(product: productsArray[indexPath.row])
        return productCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: Bundle.main)
        // swiftlint:disable line_length
        let productInfoVC = storyboard.instantiateViewController(withIdentifier: "productInfoVC") as? ProductInformationViewController
        // swiftlint:enable line_length
        productInfoVC?.product = productsArray[indexPath.row]
        self.navigationController?.pushViewController(productInfoVC!, animated: true)
    }

}
