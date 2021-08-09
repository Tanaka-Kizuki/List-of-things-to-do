//
//  DetailViewController.swift
//  List-of-things-to-do
//
//  Created by 田中築樹 on 2021/08/09.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var listName = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        listNameLabel.text = listName
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
