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
    var extraHeight: CGFloat = 0

    var bg: UIImageView! = nil
    var avatar: UIImageView! = nil
    var title: UILabel! = nil
    var subTitle: UILabel! = nil

    var leftDataView: UIView! = nil
    var rightDataView: UIView! = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(scrollView: UIScrollView, includeNavBar: Bool = false) {
        self.scrollView = scrollView
        if includeNavBar {
            self.extraHeight = 64
        }

        let w: CGFloat = UIScreen.mainScreen().bounds.width
        let h: CGFloat = 160

        super.init(frame: CGRect(x: 0, y: 0, width: w, height: h))

        //设置scroll
        self.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)

        var inset = self.scrollView.contentInset
        inset.top = inset.top + h
        self.scrollView.contentInset = inset
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }

    let bgYScale: CGFloat = 1.5
    let avatarW: CGFloat = 70
    func initUIData(bgImaName bgName: String, headImgName: String, titleStr: String, subTitleStr: String) {
        let w: CGFloat = frame.size.width
        let h: CGFloat = frame.size.height

        //裁剪背景图
        let maskView = UIView(frame: CGRect(x: 0, y: 0, width: w, height: h))
        addSubview(maskView)
        maskView.layer.masksToBounds = true

        //背景
        bg = UIImageView(image: UIImage(named: bgName))
        maskView.addSubview(bg)
        bg.frame = CGRect(x: 0, y: (1 - bgYScale) * h, width: w, height: bgYScale * h)
        bg.contentMode = .ScaleAspectFill

        //头像
        avatar = UIImageView(image: UIImage(named: headImgName))
        maskView.addSubview(avatar!)
        avatar.frame = CGRect(
            x: 0.5 * w - 0.5 * avatarW,
            y: 0.42 * h - 0.5 * avatarW,
            width: avatarW,
            height: avatarW)

        avatar.layer.cornerRadius = avatarW / 2 //圆形
        avatar.layer.masksToBounds = true //剪切掉边缘以外

        avatar.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).CGColor
        avatar.layer.borderWidth = 1.5

        //名字
        title = UILabel()
        maskView.addSubview(title!)

        title.bounds = CGRect(x: 0, y: 0, width: w, height: 0.2 * h)
        title.center.x = avatar.center.x
        title.center.y = avatar.center.y + 50

        title.textAlignment = NSTextAlignment.Center
        title.font = UIFont.systemFontOfSize(14.0)
        title.text = titleStr
        title.textColor = UIColor.whiteColor()

        title.shadowColor = UIColor.blackColor()
        title.shadowOffset = CGSize(width: 1, height: 1)

        //签名
        subTitle = UILabel()
        maskView.addSubview(subTitle!)

        subTitle.bounds = CGRect(x: 0, y: 0, width: w, height: 0.1 * h)
        subTitle.center.x = avatar.center.x
        subTitle.center.y = avatar.center.y + 70

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

        bg?.frame.origin.y = (1 - bgYScale) * frame.size.height + (bgYScale * frame.size.height + destY) * (1 - curAlpha)

        let destAvatarY = 0.58 * frame.size.height - 22
        let t = CGAffineTransformMakeTranslation(0, destAvatarY * (1 - curAlpha))
        avatar?.transform = CGAffineTransformScale(t, imgReduce, imgReduce)

        title?.transform = t
        subTitle?.transform = t

    }
}
