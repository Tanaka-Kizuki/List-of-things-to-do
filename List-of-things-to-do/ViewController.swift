//
//  ViewController.swift
//  List-of-things-to-do
//
//  Created by 田中築樹 on 2021/08/03.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        tableView.rowHeight = 200
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
                    if let name = data["name"] as? String,let near = data["near"] as? String,let url = data["url"] as? String {
                        let listModels = ListModel(name:name,near:near,url:url)
                        self.listModel.append(listModels)
                    }
                    
                }
                self.tableView.reloadData()
                
            }
            
        }
    }


    
}

