
//
//  ViewController.swift
//  List-of-things-to-do
//
//  Created by 田中築樹 on 2021/08/03.
//

import UIKit
import Firebase
import FirebaseFirestore
import SegementSlide

class CafeListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SegementSlideContentScrollViewDelegate {
    

    @IBOutlet weak var cafeTableView: UITableView!
    
    var listModel:[ListModel] = []
    var db = Firestore.firestore()
    var selectedIndexPath = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cafeTableView.delegate = self
        cafeTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        loadData()
    }
    
    @objc var scrollView: UIScrollView {
        return cafeTableView
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        tableView.rowHeight = tableView.frame.size.height / 15
        let listLabel = cell.contentView.viewWithTag(1) as! UILabel
        listLabel.numberOfLines = 0
        print(indexPath)
        listLabel.text = "\(self.listModel[indexPath.row].name)"
        return cell
    }
    
    //fireStoreからデータを取得し、listModelへ値を代入
    func loadData() {
        db.collection("doList").addSnapshotListener {(snapShot, error) in
            self.listModel = []
            if error != nil {
                return
            }
            if let snapShotDoc = snapShot?.documents {
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let name = data["name"] as? String,let near = data["near"] as? String,let tag = data["tag"] as? String,let date = data["date"] as? String {
                        if tag == "カフェ" {
                            let listModels = ListModel(name:name,near:near,tag:tag,date: date)
                            self.listModel.append(listModels)
                        }
                    }
                }
                self.cafeTableView.reloadData()
            }
        }
    }
    
    //セルをタップした時に詳細画面へ遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goDetail", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as? DetailViewController
        if let index = sender as? Int {
            selectedIndexPath = index
        }
        detailVC?.listName = listModel[selectedIndexPath].name
    }


    
}

