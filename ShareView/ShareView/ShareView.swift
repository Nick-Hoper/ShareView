//
//  ShareView.swift
//  CWShareView
//
//  Created by chenwei on 2017/8/24.
//  Copyright © 2017年 cwwise. All rights reserved.
//

import UIKit

let kSheetCellHeight: CGFloat = 130
let kItemSize = CGSize(width: 72, height: 100)

private let kShareCellIdentifier = "cell"
private let kShareSheetCellIdentifier = "sheetCell"


public typealias ShareViewClickedHandler = ((ShareView, IndexPath) -> Void)

public class ShareView: UIView {
    
    private var shareItems: [Any] = []
    
    /// header
    public var headerView: UIView?
    
    private var containerView: UIView
    
    public var footerView: UIView?
    
    public var lineView: UIView?
    
    public var collectionViewLayout: UICollectionViewFlowLayout!

    private var collectionView: UICollectionView!
            
    public var animationDuration: TimeInterval
    /// 点击事件
    public var clickedHandler: ShareViewClickedHandler?

    public convenience init() {
        let frame = UIScreen.main.bounds
        self.init(frame: frame)
    }
    
    public override init(frame: CGRect) {
        
        containerView = UIView()
        animationDuration = 0.3
        
        super.init(frame: frame)
        setupUI()
    }
    
    public convenience init(title: String? = nil, 
                            shareItems: [[ShareItem]], 
                            clickedHandler: ShareViewClickedHandler? = nil) {
        self.init()
        
        self.shareItems = shareItems
        self.clickedHandler = clickedHandler
        if let title = title {
            headerView = defaultHeaderView(with: title)   
        }
    }

    func setupUI() {
        
        containerView.backgroundColor = UIColor.white
        addSubview(containerView)
        
        // 默认布局
        footerView = defaultFooterView()
        
        lineView = defaultLineView()
        
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 15, right: 25)
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 15
        collectionViewLayout.minimumLineSpacing = 5
        collectionViewLayout.itemSize = CGSize(width: self.frame.width, height: kSheetCellHeight)
        
        
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(ShareItemCell.self, forCellWithReuseIdentifier: kShareCellIdentifier)
        collectionView.register(ShareSheetCell.self, forCellWithReuseIdentifier: kShareSheetCellIdentifier)
        containerView.addSubview(collectionView)
    }
    
    // MARK: Header && Footer
    func defaultHeaderView(with title: String) -> UIView {
        
        let contentWidth = self.frame.width
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: 30)
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.frame = CGRect(x: 0, y: 13, width: contentWidth, height: 15)
        titleLabel.text = title
        
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    //分割线
    func defaultLineView() -> UIView {
        
        let lineView = UIView()
        lineView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 5)
        lineView.backgroundColor = UIColor(hex6: 0xE8E8E8)
      
        return lineView
    }
    
    func defaultFooterView() -> UIView {

        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50)
        
        // 取消按钮
        let buttonHighlightdColor = UIColor(hex6: 0xf7f7f7)
        let buttonColor = UIColor.black
        let cancelButton = UIButton(type: .custom)
        cancelButton.backgroundColor = UIColor.white
        cancelButton.frame = footerView.bounds
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelButton.setTitleColor(buttonColor, for: .normal)
        cancelButton.setBackgroundImage(UIImage(color: buttonHighlightdColor), for: .highlighted)
        cancelButton.setTitle("取消", for: .normal)
        footerView.addSubview(cancelButton)
        
        return footerView
    }
    
    @objc func cancelButtonClicked() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.clickedHandler?(self, indexPath)
        dismiss()
    }
    
    
    /// 计算
    func setupSubViews() {

        var containerViewHeight: CGFloat = 0
        
        //头部
        if let headerView = headerView {
            containerView.addSubview(headerView)
            headerView.frame = CGRect(x: 0, y: containerViewHeight,
                                      width: headerView.frame.width, height: headerView.frame.height)
            containerViewHeight += headerView.frame.height
        }
        
        //中间
        let collectionViewHeight = calculateCollectionViewHeight()        
        collectionView.frame = CGRect(x: 0, y: containerViewHeight,
                                      width: self.frame.width, height: collectionViewHeight)
        
        containerViewHeight += collectionView.frame.height
        
        //分割线
        if let lineView = lineView{
            containerView.addSubview(lineView)
            lineView.frame = CGRect(x: 0, y: containerViewHeight,
                                      width: lineView.frame.width, height: lineView.frame.height)
            containerViewHeight += lineView.frame.height
        }
        
        
        //底部
        if let footerView = footerView {
            containerView.addSubview(footerView)
            footerView.frame = CGRect(x: 0, y: containerViewHeight,
                                      width: footerView.frame.width, height: footerView.frame.height)
            containerViewHeight += footerView.frame.height
        }
        
        // 计算 containerView
        containerView.frame = CGRect(x: 0, y: self.frame.height, 
                                     width: self.frame.width, height: containerViewHeight)
    }
    
    func calculateCollectionViewHeight() -> CGFloat {
                
        var collectionViewHeight: CGFloat = 0
        collectionViewHeight = CGFloat(shareItems.count)*kSheetCellHeight
        return collectionViewHeight
    }
    
    public func show() {
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self)

        setupSubViews()
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: { 
   
            let frame = self.containerView.frame
            self.containerView.frame = frame.offsetBy(dx: 0, dy: -frame.height)
            
        }) { (finshed) in
            
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {

    }
}

// MARK: - 显示 隐藏
extension ShareView {
    
    func dismiss() {
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: { 
            
            let frame = self.containerView.frame
            self.containerView.frame = frame.offsetBy(dx: 0, dy: frame.height)
            
        }) { (finshed) in
            self.removeFromSuperview()
        }
        
    }
    
}

extension ShareView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return shareItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kShareSheetCellIdentifier, for: indexPath) as! ShareSheetCell
        cell.shareItems = shareItems[indexPath.row] as! [ShareItem]
        cell.sheetCellClicked = { (sheetCell, index) in
            let currentIndexPath = collectionView.indexPath(for: sheetCell)!
            let selectIndexPath = IndexPath(row: index, section: currentIndexPath.row+1)
            self.clickedHandler?(self, selectIndexPath)
            self.dismiss()
        }
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
}

extension UIColor {
    convenience init(hex6: UInt32, alpha: Float = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >> 8) / divisor
        let blue    = CGFloat((hex6 & 0x0000FF) >> 0) / divisor
        self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}

extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 10, height: 10)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }
    
}
