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
    
    //メイン画面よりリスト名が代入される
    var listName = String()
    
    //検索用URL
    let baseUrl = "https://www.google.co.jp/search?q="
    

    override func viewDidLoad() {
        super.viewDidLoad()
        listNameLabel.text = listName
        // Do any additional setup after loading the view.
        openUrl()
    }
    
    func openUrl() {
        let Url = String(baseUrl + listName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        let searchUrl = URL(string:Url)
        let request = NSURLRequest(url: searchUrl!)
        webView.load(request as URLRequest)
    }
    
    //web画面のリロード
    @IBAction func reload(_ sender: Any) {
        webView.reload()
    }
    
    //web画面を戻る
    @IBAction func webBack(_ sender: Any) {
        webView.goBack()
    }
    
    //画面遷移(戻る)
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
