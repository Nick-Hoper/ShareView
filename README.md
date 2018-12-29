# ShareView

>Swift4.2编写分享UI

![test.jpg](https://github.com/Nick-Hoper/ShareView/blob/master/test.jpg)


## Features

- 完美支持Swift4.2编译
- 集成使用简单，二次开发扩展强大
- 分享菜单IU，支持点击手势


## Requirements

- iOS 9+
- Xcode 9+
- Swift 4.0+
- iPhone

## Example

        //1、配置分享视图
        var shareList: [ShareItem] = []
        let shareItem1 = ShareItem(title: "保存图片", icon: UIImage.init(named: "ico-savepic")!)
        let shareItem2 = ShareItem(title: "新浪微博", icon: UIImage.init(named: "ico-weibo")!)
        let shareItem3 = ShareItem(title: "微信好友", icon: UIImage.init(named: "ico-wechat")!)
        let shareItem4 = ShareItem(title: "朋友圈", icon: UIImage.init(named: "ico-cof")!)
        let shareItem5 = ShareItem(title: "QQ好友", icon: UIImage.init(named: "ico-qq")!)
        let shareItem6 = ShareItem(title: "QQ空间", icon: UIImage.init(named: "ico-qzone")!)
        
        shareList.append(contentsOf: [shareItem1, shareItem2, shareItem3, shareItem4,
        shareItem5, shareItem6])
        
        
        //2、点击，弹窗
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
        
更详细集成方法，根据实际的例子请查看源代码中的demo



