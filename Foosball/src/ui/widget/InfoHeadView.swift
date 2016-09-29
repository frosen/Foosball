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

    var bg: UIImageView? = nil
    var avatarBG: UIView? = nil
    var title: UILabel? = nil
    var subTitle: UILabel? = nil

    var leftDataView: UIView? = nil
    var rightDataView: UIView? = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(scrollView: UIScrollView, includeNavBar: Bool = false) {
        self.scrollView = scrollView
        if includeNavBar {
            self.extraHeight = 64 // 44 + 20
        }

        let w: CGFloat = UIScreen.main.bounds.width
        let h: CGFloat = 160

        super.init(frame: CGRect(x: 0, y: 0, width: w, height: h))

        //设置scroll
        self.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)

        var inset = self.scrollView.contentInset
        inset.top = inset.top + h
        self.scrollView.contentInset = inset
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }

    let bgYScale: CGFloat = 1.5
    let avatarW: CGFloat = 70
    func initUIData(bgImgName bgName: String, avatarURL: String?, titleStr: String, subTitleStr: String) {
        let w: CGFloat = frame.size.width
        let h: CGFloat = frame.size.height

        //裁剪背景图
        let maskViewShadow = UIView(frame: CGRect(x: 0, y: 0, width: w, height: h + extraHeight))
        addSubview(maskViewShadow)

        maskViewShadow.backgroundColor = UIColor.white
        maskViewShadow.layer.shadowColor = UIColor.gray.cgColor
        maskViewShadow.layer.shadowOpacity = 0.45
        maskViewShadow.layer.shadowRadius = 3
        maskViewShadow.layer.shadowOffset = CGSize(width: 0, height: 5)

        let maskView = UIView(frame: CGRect(x: 0, y: 0, width: maskViewShadow.frame.width, height: maskViewShadow.frame.height))
        maskViewShadow.addSubview(maskView)
        maskView.layer.masksToBounds = true

        //背景
        bg = UIImageView(image: UIImage(named: bgName))
        maskView.addSubview(bg!)
        bg!.frame = CGRect(x: 0, y: (1 - bgYScale) * h + extraHeight, width: w, height: bgYScale * h)
        bg!.contentMode = .scaleAspectFill

        //头像
        let hasAvatar = (avatarURL != nil && avatarURL != "")
        avatarBG = UITools.createAvatar(CGRect(
                x: 0.5 * w - 0.5 * avatarW,
                y: 0.42 * h - 0.5 * avatarW + extraHeight,
                width: avatarW,
                height: avatarW
            ),
            content: hasAvatar ? avatarURL! : titleStr,
            isURL: hasAvatar
        )
        maskView.addSubview(avatarBG!)

        avatarBG!.layer.shadowColor = UIColor.black.cgColor
        avatarBG!.layer.shadowOffset = CGSize(width: 1, height: 1)
        avatarBG!.layer.shadowOpacity = 0.9
        avatarBG!.layer.shadowRadius = 5

        //名字
        title = UILabel()
        maskView.addSubview(title!)

        title!.bounds = CGRect(x: 0, y: 0, width: w, height: 0.2 * h)
        title!.center.x = avatarBG!.center.x
        title!.center.y = avatarBG!.center.y + 50

        title!.textAlignment = NSTextAlignment.center
        title!.font = UIFont.systemFont(ofSize: 14.0)
        title!.text = titleStr
        title!.textColor = UIColor.white

        title!.shadowColor = UIColor.black
        title!.shadowOffset = CGSize(width: 1, height: 1)

        //签名
        subTitle = UILabel()
        maskView.addSubview(subTitle!)

        subTitle!.bounds = CGRect(x: 0, y: 0, width: w, height: 0.1 * h)
        subTitle!.center.x = avatarBG!.center.x
        subTitle!.center.y = avatarBG!.center.y + 70

        subTitle!.textAlignment = NSTextAlignment.center
        subTitle!.font = UIFont.systemFont(ofSize: 11.0)
        subTitle!.text = subTitleStr
        subTitle!.textColor = UIColor.white

        subTitle!.shadowColor = UIColor.black
        subTitle!.shadowOffset = CGSize(width: 1, height: 1)
    }

    //设置比赛数据，同时显示左右数据视图
    func initMatchData(fight: Int, honor: Int) {
        //左侧视图


        //右侧视图
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let newOffset = (change![.newKey] as! NSValue).cgPointValue
        updateSubViewsWithScrollOffsetY(newOffset.y)
    }

    let destY: CGFloat = -64 //44 + 20
    func updateSubViewsWithScrollOffsetY(_ newOffsetY: CGFloat){
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

        let rate = 1 - curY / dis
        let curAlpha = 1 - curY / (dis - extraHeight * 1.5) //为了在有nav时更早的隐藏，以便不遮挡其他UI
        let imgReduce = 1 - 0.5 * curY / dis

        title?.alpha = curAlpha
        subTitle?.alpha = curAlpha
        frame.origin.y = -curY

        bg?.frame.origin.y = (1 - bgYScale) * frame.size.height + (bgYScale * frame.size.height + destY) * (1 - rate) + extraHeight

        let destAvatarY = 0.58 * frame.size.height - 22
        let t = CGAffineTransform(translationX: 0, y: destAvatarY * (1 - rate))
        avatarBG?.transform = t.scaledBy(x: imgReduce, y: imgReduce)

        title?.transform = t
        subTitle?.transform = t

    }
}
