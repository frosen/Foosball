//
//  InfoHeadView.swift
//  Foosball
//
//  Created by 卢乐颜 on 16/7/25.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class InfoHeadView: UIView {
    var scrollView: UIScrollView
    var extraHeight: CGFloat

    var bg: UIImageView! = nil
    var avatar: UIImageView! = nil
    var title: UILabel! = nil
    var subTitle: UILabel! = nil

    var leftDataView: UIView! = nil
    var rightDataView: UIView! = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(scrollView: UIScrollView, extraHeight: CGFloat) {
        self.scrollView = scrollView
        self.extraHeight = extraHeight

        let w: CGFloat = UIScreen.mainScreen().bounds.width
        let h: CGFloat = 160

        super.init(frame: CGRect(x: 0, y: 0, width: w, height: h))

        //设置scroll
        self.scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)

        var inset = self.scrollView.contentInset
        inset.top = inset.top + h
        self.scrollView.contentInset = inset
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }

    func initUIData(bgImaName bgName: String, headImgName: String, titleStr: String, subTitleStr: String) {
        let w: CGFloat = frame.size.width
        let h: CGFloat = frame.size.height

        //背景
        bg = UIImageView(image: UIImage(named: bgName))
        addSubview(bg)
        bg.frame = CGRect(x: 0, y: 0, width: w, height: h)
        bg.contentMode = .ScaleAspectFill

        //头像
        avatar = UIImageView(image: UIImage(named: headImgName))
        addSubview(avatar!)
        let avatarW: CGFloat = 70
        avatar!.snp_makeConstraints{ make in
            make.size.equalTo(CGSize(width: avatarW, height: avatarW))
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-13.0)
        }

        avatar.layer.cornerRadius = avatarW / 2 //圆形
        avatar.layer.masksToBounds = true //剪切掉边缘以外

        avatar.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).CGColor
        avatar.layer.borderWidth = 1.5

        //名字
        title = UILabel()
        addSubview(title!)
        title.snp_makeConstraints{ make in
            make.size.equalTo(CGSize(width: w, height: CGFloat(h) * 0.2))
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.snp_bottom).offset(-43.0)
        }
        title.textAlignment = NSTextAlignment.Center
        title.font = UIFont.systemFontOfSize(14.0)
        title.text = titleStr
        title.textColor = UIColor.whiteColor()

        title.shadowColor = UIColor.blackColor()
        title.shadowOffset = CGSize(width: 1, height: 1)

        //签名
        subTitle = UILabel()
        addSubview(subTitle!)
        subTitle.snp_makeConstraints{ make in
            make.size.equalTo(CGSize(width: w, height: CGFloat(h) * 0.1))
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.snp_bottom).offset(-24.0)
        }
        subTitle.textAlignment = NSTextAlignment.Center
        subTitle.font = UIFont.systemFontOfSize(11.0)
        subTitle.text = subTitleStr
        subTitle.textColor = UIColor.whiteColor()

        subTitle.shadowColor = UIColor.blackColor()
        subTitle.shadowOffset = CGSize(width: 1, height: 1)
    }

    //设置比赛数据，同时显示左右数据视图
    func initMatchData(fight fight: Int, honor: Int) {
        //左侧视图

        //右侧视图
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let newOffset = change!["new"]?.CGPointValue
        updateSubViewsWithScrollOffsetY(newOffset!.y)
    }

    let destY: CGFloat = -64 //44 + 20
    func updateSubViewsWithScrollOffsetY(newOffsetY: CGFloat){
        let startY = -(scrollView.contentInset.top)
        let dis = destY - startY

        var realOffsetY: CGFloat
        //计算位置
        if newOffsetY < startY {
            realOffsetY = startY
        } else if newOffsetY < destY {
            realOffsetY = newOffsetY
        } else {
            realOffsetY = destY
        }

        let curY = realOffsetY - startY

        let curAlpha = 1 - curY / dis
        let imgReduce = 1 - 0.5 * curY / dis

        title?.alpha = curAlpha
        subTitle?.alpha = curAlpha
        frame.origin.y = -curY
        print(dis, curY)



        

    }
}
