//
//  CreateViewController.swift
//  List-of-things-to-do
//
//  Created by 田中築樹 on 2021/08/03.
//

import UIKit
import Firebase
import FirebaseFirestore


class CreateViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var doTextField: UITextField!
    @IBOutlet weak var nearTextField: UITextField!
    @IBOutlet weak var DoButton: UIButton!
    @IBOutlet weak var cafeButton: UIButton!
    
    var db = Firestore.firestore().collection("doList")
    
    var tag = "やりたいこと"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doTextField.delegate = self
        nearTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doAction(_ sender: Any) {
        checkTag()
    }
    
    @IBAction func cafeAction(_ sender: Any) {
        checkTag()
    }
    
    func checkTag() {
        let check = UIImage(named:"checkbox")
        let checked = UIImage(named:"checkedbox")
        //もし変数tagが"やりたいこと"であれば、
        if tag == "やりたいこと" {
        //doButtonの画像をcheckに変えて、cafeButtonをcheckedに変える
            DoButton.setImage(check,for: UIControl.State.normal)
            cafeButton.setImage(checked,for: UIControl.State.normal)
            self.tag = "カフェ"
        //もし変数tagが"カフェ"であれば、
        } else {
            //doButtonの画像をcheckedに変えて、cafeButtonをcheckに変える
            DoButton.setImage(checked,for: UIControl.State.normal)
            cafeButton.setImage(check,for: UIControl.State.normal)
            self.tag = "やりたいこと"
        }
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
    
    //リストの内容をFirebaseStoreに保存して、メイン画面へ遷移
    @IBAction func save(_ sender: Any) {
        if doTextField.text != nil {
            db.document().setData(["name":doTextField.text as Any,"near":nearTextField.text,"tag":self.tag,"date":""])
        }
        dismiss(animated: true, completion: nil)
    }
    
    //メイン画面への遷移
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
