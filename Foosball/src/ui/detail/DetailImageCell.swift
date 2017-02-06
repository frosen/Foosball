//
//  DetailImageCell.swift
//  Foosball
//
//  Created by luleyan on 16/10/12.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import SDWebImage

class DetailImageHeadCell: DetailHeadCell {
    override func initData(_ d: BaseData?, index: IndexPath?) {
        selectionStyle = .none //使选中后没有反应
        DetailHeadCell.createHead(contentView, s: "瞬间", h: h)
    }
}

class DetailImageCell: StaticCell, SKPhotoBrowserDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private static let imageCountIn1Line: CGFloat = 4
    private static let imgMargin: CGFloat = 1
    private static let imageViewWidth: CGFloat = (DetailG.widthWithoutMargin + 2 * imgMargin) / imageCountIn1Line

    private var imgListView: UIView? = nil
    private var imgViewArray: [UIImageView] = []
    private var imgUrlList: [Int: String] = [:]

    private var imgAddBtn: UIView! = nil // 在这个按钮上展示上传进度

    var curEvent: Event! = nil

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil, otherData: Any? = nil) -> CGFloat {
        let e = d as! Event
        let lineCount = ceil(CGFloat(e.imageURLList.count + 1) / imageCountIn1Line)
        return lineCount * imageViewWidth
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        // 如果变了，就要清理掉原来的内容，并重建
        if imgListView != nil {
            imgListView!.removeFromSuperview()
            imgViewArray = []
        }
        let margin = DetailG.headMargin - DetailImageCell.imgMargin
        imgListView = UIView(frame: CGRect(x: margin, y: 0, width: 99999, height: 99999))
        contentView.addSubview(imgListView!)

        curEvent = d as! Event
        var pos: Int = 0
        var line: Int = 0
        var index: Int = 0
        for imgUrl in curEvent.imageURLList {
            let v = createImageView(url: imgUrl, index: index)
            imgListView!.addSubview(v)
            v.frame.origin = CGPoint(
                x: CGFloat(pos) * DetailImageCell.imageViewWidth,
                y: CGFloat(line) * DetailImageCell.imageViewWidth
            )

            pos += 1
            if pos >= Int(DetailImageCell.imageCountIn1Line) {
                pos = 0
                line += 1
            }
            index += 1
        }

        if imgAddBtn == nil {
            imgAddBtn = createNewBtn()
            imgListView!.addSubview(imgAddBtn)
        }

        imgAddBtn.frame.origin = CGPoint(
            x: CGFloat(pos) * DetailImageCell.imageViewWidth,
            y: CGFloat(line) * DetailImageCell.imageViewWidth
        )

        // 提示 todo
        if curEvent.imageURLList.count == 0 {

        }
    }

    private func createImageView(url: String, index: Int) -> UIView {
        let v = UIView()
        v.bounds = CGRect(x: 0, y: 0, width: DetailImageCell.imageViewWidth, height: DetailImageCell.imageViewWidth)

        //添加图片
        let imgWidth = DetailImageCell.imageViewWidth - 2 * DetailImageCell.imgMargin
        let img = UIImageView(frame: CGRect(
            x: DetailImageCell.imgMargin,
            y: DetailImageCell.imgMargin,
            width: imgWidth,
            height: imgWidth
        ))
        v.addSubview(img)

        let imgUrlStr = APP.activeEventsMgr.getImgUrlStr(from: url, useCut: true)
        img.sd_setImage(with: URL(string: imgUrlStr), placeholderImage: #imageLiteral(resourceName: "img_default"))
        img.tag = index

        v.tag = index
        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailImageCell.tapImageView(ges:)))
        v.addGestureRecognizer(tap)

        let longP = UILongPressGestureRecognizer(target: self, action: #selector(DetailImageCell.longPressImageView(ges:)))
        v.addGestureRecognizer(longP)

        imgViewArray.append(img)
        imgUrlList[index] = url

        return v
    }

    private func createNewBtn() -> UIView {
        let v = UIView()
        v.bounds = CGRect(x: 0, y: 0, width: DetailImageCell.imageViewWidth, height: DetailImageCell.imageViewWidth)

        let imgWidth = DetailImageCell.imageViewWidth - 2 * DetailImageCell.imgMargin
        let btn = UIButton(type: .custom)
        v.addSubview(btn)
        btn.frame = CGRect(
            x: DetailImageCell.imgMargin,
            y: DetailImageCell.imgMargin,
            width: imgWidth,
            height: imgWidth
        )
        btn.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        btn.backgroundColor = UIColor(white: 0.91, alpha: 1.0)
        btn.addTarget(self, action: #selector(DetailImageCell.onClickNew), for: .touchUpInside)

        return v
    }

    // 图片详情 ------------------------------------------------------------------

    func tapImageView(ges: UITapGestureRecognizer) {
        print("tapImageView")
        let index = ges.view!.tag

        var skImgArray: [SKPhoto] = []
        for imgV in imgViewArray {
            if let img = imgV.image {
                let tag = imgV.tag
                let bigImgUrlStr = APP.activeEventsMgr.getImgUrlStr(from: curEvent.imageURLList[tag])
                let photo = SKPhoto.photoWithImageURL(bigImgUrlStr, holder: img)
                photo.shouldCachePhotoURLImage = true
                skImgArray.append(photo)
            }
        }
        let originImg = imgViewArray[index].image!
        let browser = SKPhotoBrowser(originImage: originImg, photos: skImgArray, animatedFromView: self)
        browser.initializePageIndex(index)
        ctrlr.present(browser, animated: true, completion: {})
    }

    func longPressImageView(ges: UILongPressGestureRecognizer) {
        if ges.state != .began {
            return
        }
        removePhoto(ges.view!.tag)
    }

    func removePhoto(_ index: Int) {
        print("deleta img: ", index)
        UITools.showAlert(ctrlr, title: "删除图片", msg: "您确定要删除这张图片吗？", type: 2, callback: { _ in
            print("confirm to delete")
            let detailCtrlr = self.ctrlr as! DetailViewController
            APP.activeEventsMgr.changeData(changeFunc: { data in

                guard let e = data.getCurEvent(curId: detailCtrlr.curEventId) else {
                    print("ERROR: no event in removePhoto changeData")
                    return nil
                }

                // 之所以要重新搜索一遍，是因为过程中有可能更新了
                let removeUrl: String = self.imgUrlList[index]!
                for i in 0 ..< e.imageURLList.count {
                    if removeUrl == e.imageURLList[i] {
                        e.imageURLList.remove(at: i)
                        break
                    }
                }

                return nil
            }, needUpload: ["img": "rm"])
        })
    }

    // 获取图片 ---------------------------------------------------------------------

    func onClickNew() {
        let alert = UIAlertController(title: "请选择照片来源", message: nil, preferredStyle: .actionSheet)

        let fromPhoto = UIAlertAction(title: "拍照", style: .default) { _ in self.onClickPhoto() }
        let fromAlbum = UIAlertAction(title: "从相册获取", style: .default) { _ in self.onClickAlbum() }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)

        alert.addAction(fromPhoto)
        alert.addAction(fromAlbum)
        alert.addAction(cancelAction)

        ctrlr.present(alert, animated: true, completion: nil)
    }

    // 拍照
    func onClickPhoto() {
        print("photo")
        startImagePicker(.camera, str: "拍照设备")
    }

    func onClickAlbum() {
        print("album")
        let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        startImagePicker(hasCamera ? .photoLibrary : .savedPhotosAlbum, str: "相册")
    }

    func startImagePicker(_ t: UIImagePickerControllerSourceType, str: String) {
        if UIImagePickerController.isSourceTypeAvailable(t) {
            let pickerCtrller = UIImagePickerController()
            pickerCtrller.delegate = self
            pickerCtrller.sourceType = t
            pickerCtrller.allowsEditing = true
            pickerCtrller.modalTransitionStyle = .coverVertical
            pickerCtrller.view.tintColor = UIColor.white
            ctrlr.present(pickerCtrller, animated: true, completion: nil)
        } else {
            UITools.showAlert(ctrlr, title: "提示", msg: "设备不支持访问" + str + "，请在设置->隐私中进行设置！", type: 1, callback: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取图片
        let img: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage

        //切换场景后更新cell
        picker.dismiss(animated: true)

        upload(img: img)
    }

    func upload(img: UIImage) {
        //转圈
        showUploading(true, img: img)

        //上传图片，获取url，如果没有网，则提示是否重复，还是保存本地/取消
        let detailCtrlr = self.ctrlr as! DetailViewController
        APP.activeEventsMgr.addNewImg(img, eventId: detailCtrlr.curEventId, obKey: detailCtrlr.DataObKey) { str, progress in
            if str == "p" {
                self.setUploading(progress: progress)
            } else if str == "fail" {
                UITools.showAlert(detailCtrlr, title: "错误", msg: "上传图片有误，是否重新上传？", type: 2, callback: { _ in
                    self.upload(img: img)
                }) { _ in
                    self.showUploading(false) //取消转圈
                }
            } else {
                // 成功后，先暂存图片
                let cutUrlStr = APP.activeEventsMgr.getImgUrlStr(from: str, useCut: true)
                SDWebImageManager.shared().saveImage(toCache: img, for: URL(string: cutUrlStr)!)
                SDWebImageManager.shared().saveImage(toCache: img, for: URL(string: str)!)
                self.showUploading(false, img: nil)
            }
        }
    }

    private var isLoading: Bool = false
    private func showUploading(_ b: Bool, img: UIImage? = nil) {
        if b == isLoading {
            return
        }
        isLoading = b
        imgAddBtn.isUserInteractionEnabled = !b

        if b {
            let imgV = UIImageView(image: img)
            imgAddBtn.addSubview(imgV)
            imgV.frame = CGRect(origin: CGPoint.zero, size: imgAddBtn.frame.size)
            imgV.tag = 1

            let progress = UIView()
            imgAddBtn.addSubview(progress)
            progress.frame = CGRect(origin: CGPoint.zero, size: imgAddBtn.frame.size)
            progress.backgroundColor = UIColor(white: 0, alpha: 0.7)
            progress.tag = 2
        } else {
            imgAddBtn.viewWithTag(2)?.removeFromSuperview()
            imgAddBtn.viewWithTag(1)?.removeFromSuperview()
        }
    }

    private func setUploading(progress: Int) {
        guard let progressView = imgAddBtn.viewWithTag(2) else {
            return
        }

        progressView.frame.size.height = imgAddBtn.frame.height * CGFloat(100 - progress) * 0.01
    }
}


