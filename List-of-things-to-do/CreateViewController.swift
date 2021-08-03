//
//  CreateViewController.swift
//  List-of-things-to-do
//
//  Created by 田中築樹 on 2021/08/03.
//

import UIKit
import Firebase
import FirebaseFirestore

var list:[List] = []
var db = Firestore.firestore().collection("doList")


class CreateViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var doTextField: UITextField!
    @IBOutlet weak var nearTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doTextField.delegate = self
        nearTextField.delegate = self
        urlTextField.delegate = self
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
    
    //textFieldでreturnキーを押したらキーボードが閉じる
    func textFieldShouldReturn(_ textField:UITextField) ->Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func save(_ sender: Any) {
        if doTextField.text != nil {
            db.document().setData(["name":doTextField.text,"near":nearTextField.text,"url":urlTextField.text])
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
