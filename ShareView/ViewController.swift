//
//  ViewController.swift
//  ShareView
//
//  Created by Nick luo on 2018/9/27.
//  Copyright © 2018年 ZB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var shareList: [ShareItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupList()
    }
    
    func setupList() {
        
        let shareItem1 = ShareItem(title: "保存图片", icon: UIImage.init(named: "ico-savepic")!)
        let shareItem2 = ShareItem(title: "新浪微博", icon: UIImage.init(named: "ico-weibo")!)
        let shareItem3 = ShareItem(title: "微信好友", icon: UIImage.init(named: "ico-wechat")!)
        let shareItem4 = ShareItem(title: "朋友圈", icon: UIImage.init(named: "ico-cof")!)
        let shareItem5 = ShareItem(title: "QQ好友", icon: UIImage.init(named: "ico-qq")!)
        let shareItem6 = ShareItem(title: "QQ空间", icon: UIImage.init(named: "ico-qzone")!)
        
        shareList.append(contentsOf: [shareItem1, shareItem2, shareItem3, shareItem4,
                                       shareItem5, shareItem6])
    }
    
    
    
    @IBAction func buttonClick(_ sender: UIButton) {
        
        let clickedHandler = { (shareView: ShareView, indexPath: IndexPath) in
            print(indexPath.section, indexPath.row)
        }
        
        let title = "分享到"
        let shareView = ShareView(title: title,
                                  shareItems: [shareList],
                                  clickedHandler: clickedHandler)
        shareView.show()
    }



}

