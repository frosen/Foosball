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
    var viewMask: UIView! = nil
    var avatar: Avatar! = nil
    var title: UILabel! = nil
    var subTitle: UILabel! = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(scrollView: UIScrollView, extraHeight: CGFloat? = nil) {
        self.scrollView = scrollView
        if extraHeight != nil {
            self.extraHeight = extraHeight!
        }

        let w: CGFloat = UIScreen.main.bounds.width
        let h: CGFloat = 200

        super.init(frame: CGRect(x: 0, y: 0, width: w, height: h))

        //设置scroll
        self.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)

        var inset = self.scrollView.contentInset
        inset.top = inset.top + h + self.extraHeight
        self.scrollView.contentInset = inset
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset

        initUI()
    }

    let topMargin: CGFloat = 80
    let bottomMargin: CGFloat = 120
    let avatarW: CGFloat = 70
    private func initUI() {
        let w: CGFloat = frame.size.width
        let h: CGFloat = frame.size.height

        //裁剪背景图
        let maskViewShadow = UIView(frame: CGRect(x: 0, y: -bottomMargin, width: w, height: h + extraHeight + bottomMargin))
        addSubview(maskViewShadow)

        maskViewShadow.backgroundColor = UIColor.white

        viewMask = UIView(frame: CGRect(x: 0, y: 0, width: maskViewShadow.frame.width, height: maskViewShadow.frame.height))
        maskViewShadow.addSubview(viewMask)
        viewMask.layer.masksToBounds = true

        //背景
        bg = UIImageView()
        viewMask.addSubview(bg)
        bg.frame = CGRect(x: 0, y: extraHeight - topMargin + bottomMargin, width: w, height: h + topMargin + bottomMargin + extraHeight)
        bg.contentMode = .scaleAspectFill

        //名字
        title = UILabel()
        viewMask.addSubview(title)

        title.bounds = CGRect(x: 0, y: bottomMargin, width: w, height: 0.2 * h)
        title.center.x = 0.5 * w
        title.center.y = 0.42 * h + extraHeight + bottomMargin + 55

        title.textAlignment = NSTextAlignment.center
        title.font = UIFont.systemFont(ofSize: 14.0)

        title.textColor = UIColor.white

        title.shadowColor = UIColor.darkGray
        title.shadowOffset = CGSize(width: 0, height: 1)

        //签名
        subTitle = UILabel()
        viewMask.addSubview(subTitle)

        subTitle.bounds = CGRect(x: 0, y: bottomMargin, width: w, height: 0.1 * h)
        subTitle.center.x = 0.5 * w
        subTitle.center.y = 0.42 * h + extraHeight + bottomMargin + 80

        subTitle.textAlignment = NSTextAlignment.center
        subTitle.font = UIFont.systemFont(ofSize: 11.0)
        subTitle.textColor = UIColor.white

        subTitle.shadowColor = UIColor.darkGray
        subTitle.shadowOffset = CGSize(width: 0, height: 1)
    }

    func resetData(bgImgName bgName: String, avatarURL: String, titleStr: String, subTitleStr: String) {
        let w: CGFloat = frame.size.width
        let h: CGFloat = frame.size.height

        //头像
        if avatar != nil {
            avatar.removeFromSuperview()
        }

        avatar = Avatar.create(rect: CGRect(
            x: 0.5 * w - 0.5 * avatarW,
            y: 0.42 * h - 0.5 * avatarW + extraHeight + bottomMargin,
            width: avatarW,
            height: avatarW
            ),
            name: titleStr,
            url: avatarURL
        )
        viewMask.addSubview(avatar)

        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.layer.borderWidth = 2

        //其他属性
        bg.image = UIImage(named: bgName)
        title.text = titleStr
        subTitle.text = subTitleStr
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let newOffset = (change![.newKey] as! NSValue).cgPointValue
        updateSubViewsWithScrollOffsetY(newOffset.y)
    }

    private let destY: CGFloat = -64 //44 + 20
    private func updateSubViewsWithScrollOffsetY(_ newOffsetY: CGFloat){
        let startY = -(scrollView.contentInset.top)
        let dis = destY - startY

        var realOffsetY: CGFloat
        //计算位置
        let startLimit = startY - bottomMargin * 0.5
        if newOffsetY < startLimit {
            realOffsetY = startLimit
            return
        } else if newOffsetY < destY {
            realOffsetY = newOffsetY
        } else {
            realOffsetY = destY
        }

        let curY = realOffsetY - startY

        let rate = 1 - curY / dis
        let curAlpha = 1 - curY / (dis - extraHeight * 1.5) //为了在有nav时更早的隐藏，以便不遮挡其他UI
        let imgReduce = min(0.5 + 0.5 * rate, 1) //不可大于1倍

        title?.alpha = curAlpha
        subTitle?.alpha = curAlpha
        frame.origin.y = -curY

        bg?.frame.origin.y = extraHeight - topMargin + bottomMargin + (frame.size.height + topMargin + destY) * (1 - rate)

        let destAvatarY = 0.58 * frame.size.height - 22
        let t = CGAffineTransform(translationX: 0, y: destAvatarY * (1 - rate))
        avatar?.transform = t.scaledBy(x: imgReduce, y: imgReduce)

        title?.transform = t
        subTitle?.transform = t

    }
}
