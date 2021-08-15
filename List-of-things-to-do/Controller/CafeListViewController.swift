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

class CafeListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SegementSlideContentScrollViewDelegate,UITextFieldDelegate {
    
 
    @IBOutlet weak var tableView: UITableView!
    
    var listModel:[ListModel] = []
    var db = Firestore.firestore()
    var selectedIndexPath = Int()
    
    let datePicker = UIDatePicker()
    var datePickerLabel = String()
    
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
        listLabel.text = "\(self.listModel[indexPath.row].name)"
        
        let listTextField = cell.contentView.viewWithTag(2) as! UITextField
        listTextField.delegate = self
        listTextField.text = nil
        listTextField.text = listModel[indexPath.row].date
//        let cellTextField = UITextField()
//        cellTextField.tag = indexPath.row
//        cellTextField.frame = CGRect(x:233, y:0, width:135, height: 38)
//        cellTextField.delegate = self
//        cellTextField.text = nil
//        cellTextField.text = listModel[indexPath.row].date
//        cell.contentView.addSubview(cellTextField)
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
                    if let name = data["name"] as? String,let near = data["near"] as? String,let tag = data["tag"] as? String,let date = data["date"] as? String{
                        if tag == "カフェ" {
                            let listModels = ListModel(name:name,near:near,tag:tag,date: date)
                            self.listModel.append(listModels)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    //セルをタップした時に詳細画面へ遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //タップの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        //画面遷移
        performSegue(withIdentifier: "goDetail", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as? DetailViewController
        if let index = sender as? Int {
            selectedIndexPath = index
        }
        detailVC?.listName = listModel[selectedIndexPath].name
    }
    
    //テキストフィールドを選択した時
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //datePickerのロード
        datePickerlaod(textField: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cell = textField.superview?.superview as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell){
            let listName = listModel[indexPath.row].name
            db.collection("doList")
                .whereField("name", isEqualTo:listName)
                .getDocuments(completion: {
                    (querySnapshot,error) in
                    if error != nil {
                        return
                    } else {
                        let id = querySnapshot?.documents.first?.documentID  // 結果のドキュメントIDをとる1
                        let document = Firestore.firestore().collection("doList").document(id!) // IDと一致する書き換えできるドキュメントをとる
                        document.updateData([
                            "date": self.datePickerLabel // 行った日付を更新
                        ])
                        { err in
                            if let err = err { // エラーハンドリング
                                print("Error updating document: \(err)")
                            } else { // 書き換え成功ハンドリング
                                print("Update successfully!")
                            }
                        }
                    }
                })
          }
    }
    
    func datePickerlaod(textField:UITextField) {
        //スタイルをドラムロールへ
        datePicker.preferredDatePickerStyle = .wheels
        // DatePickerModeをDate(日付)に設定
        datePicker.datePickerMode = .date
        // DatePickerを日本語化
        datePicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        // textFieldのinputViewにdatepickerを設定
        textField.inputView = datePicker
        // UIToolbarを設定
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // Doneボタンを設定(押下時doneClickedが起動)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        // Doneボタンを追加
        toolbar.setItems([doneButton], animated: true)
        // FieldにToolbarを追加
        textField.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked() {
        let dateFormatter = DateFormatter()
        // 持ってくるデータのフォーマットを設定
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale    = NSLocale(localeIdentifier: "ja_JP") as Locale?
        dateFormatter.dateStyle = DateFormatter.Style.medium
        datePickerLabel = dateFormatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
}

