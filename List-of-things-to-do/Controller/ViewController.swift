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

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SegementSlideContentScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listModel:[ListModel] = []
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        loadData()
    }
    
    @objc var scrollView: UIScrollView {
        return tableView
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
    
    func loadData() {
        db.collection("doList").addSnapshotListener {(snapShot, error) in
            
            self.listModel = []

            if error != nil {
                return
            }
            
            if let snapShotDoc = snapShot?.documents {
                
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let name = data["name"] as? String,let near = data["near"] as? String,let tag = data["tag"] as? String {
                        if tag == "やりたいこと" {
                            let listModels = ListModel(name:name,near:near,tag:tag)
                            self.listModel.append(listModels)
                        }
                    }
                    
                }
                self.tableView.reloadData()
                
            }
            
        }
    }


    
}

