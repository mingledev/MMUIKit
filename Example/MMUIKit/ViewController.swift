//
//  ViewController.swift
//  MMUIKit
//
//  Created by Mingle on 02/16/2022.
//  Copyright (c) 2022 Mingle. All rights reserved.
//

import UIKit
import MMUIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let btn = MMButton(frame: CGRect(x: 20, y: 100, width: 200, height: 200))
        btn.backgroundColor = UIColor.randomColor
        btn.imgLocation = .right
        btn.spacing = 8
        btn.setImage(UIImage(named: "search"), for: .normal)
        btn.setTitle("123", for: .normal)
        view.addSubview(btn)
        btn.addGesture(type: UITapGestureRecognizer.self, target: self, action: #selector(action))
        
        var bar = MMBarView(location: .top)
        bar.backgroundColor = .randomColor
        view.addSubview(bar)
        
        bar = MMBarView(location: .bottom)
        bar.backgroundColor = .randomColor
        view.addSubview(bar)
    }
    
    @objc func action() {
        debugPrint("tap")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       let alert = MMAlertView.show(title: "请输入账号\n密码", content: "请输入账号密码", cancelButtonTitle: "取消", otherButtonTitle: "确定")
        let phoneTF = UITextField()
        phoneTF.borderStyle = .roundedRect
        alert.addTextField(phoneTF)
        let pwdTF = UITextField()
        pwdTF.borderStyle = .roundedRect
        pwdTF.isSecureTextEntry = true
        alert.addTextField(pwdTF)
        
        let customerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        customerView.backgroundColor = .randomColor
        alert.addCustomerView(customerView)
        alert.buttonOnClick = { (view, index) in
            debugPrint("\(phoneTF.text ?? "")\n\(pwdTF.text ?? "")")
            view.hide()
            return false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

