//
//  ViewController.swift
//  MMUIKit
//
//  Created by Mingle on 02/16/2022.
//  Copyright (c) 2022 Mingle. All rights reserved.
//

import UIKit
import MMUIKit

class ViewController: MMPageViewController {
    
    let colors: [UIColor] = [.red, .green, .blue]
    let loopView = MMLoopView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let btn = MMButton(frame: CGRect(x: 20, y: 220, width: 200, height: 200))
//        btn.backgroundColor = UIColor.randomColor
//        btn.imgLocation = .right
//        btn.spacing = 8
//        btn.setImage(UIImage(named: "search"), for: .normal)
//        btn.setTitle("123", for: .normal)
//        view.addSubview(btn)
//        btn.addGesture(type: UITapGestureRecognizer.self, target: self, action: #selector(action))
////
////        var bar = MMBarView(location: .top)
////        bar.backgroundColor = .randomColor
////        view.addSubview(bar)
////
////        bar = MMBarView(location: .bottom)
////        bar.backgroundColor = .randomColor
////        view.addSubview(bar)
//
//
//        loopView.frame = CGRect(x: 0, y: 0, width: view.mWidth, height: 200)
//        loopView.delegate = self
//        loopView.autoLoop = true
//        loopView.loopTimeInterval = 3
//        view.addSubview(loopView)
//        loopView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
//        loopView.index = 2
        let vc1 = SubVC()
        vc1.title = "vc1"
//        vc1.view.backgroundColor = .red
        let vc2 = SubVC()
        vc2.title = "vc2"
//        vc2.view.backgroundColor = .green
        let vc3 = SubVC()
        vc3.title = "vc3"
        let vc4 = SubVC()
        vc4.title = "vc4"
        let vc5 = SubVC()
        vc5.title = "vc5"
//        vc3.view.backgroundColor = .blue
        let cate = MMPageCategoryView()
        cate.mHeight = 44
//        cate.selectedFont = .systemFont(ofSize: 16, weight: .bold)
        cate.titles = ["发奇偶安慰奖佛尔交完费", "发外交佛教", "金佛为埃及", "更接近工具人", "福娃"]
        subViewControllers = [vc1, vc2, vc3, vc4, vc5]
        categoryView = cate
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        loopView.frame = CGRect(x: 0, y: 0, width: view.mWidth, height: 200)
    }
    
    @objc func action() {
//        let action = MMActionSheet.show(title: "标题", content: "内容", cancelButtonTitle: "取消", otherButtonTitle: "确定", "销毁")
//        action.buttonOnClick = { (alert, index) in
//            debugPrint("\(index)")
//            return true
//        }
        let pageTF = UITextField()
        pageTF.borderStyle = .roundedRect
        let alert = MMAlertView.show(title: "页码", content: "请输入", cancelButtonTitle: "取消", otherButtonTitle: "确定", "开关自动滚动")
        alert.addTextField(pageTF)
        alert.buttonOnClick = { (_, index) in
            if index == 0 {
                self.loopView.index = Int(pageTF.text ?? "0") ?? 0
            }
            if index == 1 {
                self.loopView.autoLoop = !self.loopView.autoLoop
            }
            return true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func numberOfLoopView(_ loopView: MMLoopView) -> Int {
//        return colors.count
//    }
//
//    func cellForIndexOfLoopView(_ loopView: MMLoopView, _ index: Int) -> UICollectionViewCell {
//        let cell = loopView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: index)
//        cell.contentView.backgroundColor = colors[index]
//        return cell
//    }
//
//    func didSelectIndexOfLoopView(_ loopView: MMLoopView, _ index: Int) {
//        print("\(index)")
//    }
//
//    func didScrollToIndexOfLoopView(_ loopView: MMLoopView, _ index: Int) {
//        print("\(index)")
//    }
}

class SubVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .randomColor
        print("viewDidLoad \(self.title ?? "")")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear \(self.title ?? "")")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear \(self.title ?? "")")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear \(self.title ?? "")")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear \(self.title ?? "")")
    }
}
