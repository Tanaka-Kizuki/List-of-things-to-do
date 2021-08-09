//
//  SlideViewController.swift
//  List-of-things-to-do
//
//  Created by 田中築樹 on 2021/08/09.
//

import UIKit
import SegementSlide

class SlideViewController: SegementSlideDefaultViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadData()
        defaultSelectedIndex = 0
    }
    
    override var titlesInSwitcher: [String] {
        return ["やりたいこと","カフェ"]
    }

    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {



        switch index {
            case 0:
                let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! ViewController
                return homeVC
            case 1:
                let cafeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cafeVC") as! CafeListViewController
                return cafeVC
            default:
                let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! ViewController
                return homeVC
        }
    }
    
    override var switcherHeight: CGFloat {
        return 30
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
