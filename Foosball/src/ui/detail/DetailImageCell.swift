//
//  DetailImageCell.swift
//  Foosball
//
//  Created by luleyan on 16/10/12.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class DetailImageHeadCell: DetailHeadCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应

        createHead("瞬间")
        createButton("拍照", color: UIColor.blue, pos: 0, callback: #selector(DetailImageHeadCell.onClickPhoto))
        createButton("图库", color: UIColor.red, pos: 1, callback: #selector(DetailImageHeadCell.onClickAlbum))
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
            let ctrller = UIImagePickerController()
            ctrller.delegate = self
            ctrller.sourceType = t
            ctrller.allowsEditing = true
            ctrller.modalTransitionStyle = .coverVertical
            ctrlr.present(ctrller, animated: true, completion: nil)
        } else {
            UITools.showAlert(ctrlr, title: "提示", msg: "设备不支持访问" + str + "，请在设置->隐私中进行设置！", type: 1, callback: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取图片
        let img: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage

        //转圈

        //上传图片，获取url，如果没有网，则提示是否重复，还是保存本地/取消

        //取消转圈

        //更新event，并上传，然后更新cell
        let detailCtrlr = self.ctrlr as! DetailViewController
        var cellIndex = detailCtrlr.tableView.indexPath(for: self)!
        cellIndex.row += 1 //这里是标题，取标题下一个cell
        detailCtrlr.changeEvent(cellIndex, changeType: "C") { event in
            event.imageURLList.append("http://up.qqjia.com/z/25/tu32700_3.png")
        }

        //切换场景后更新cell
        picker.dismiss(animated: true)
    }
}

class DetailImageCell: StaticCell, SKPhotoBrowserDelegate {
    static let imageCountIn1Line: CGFloat = 4
    static let imgMargin: CGFloat = 2
    static let imageViewWidth: CGFloat = (DetailG.widthWithoutMargin + 2 * imgMargin) / imageCountIn1Line
    static let imgTopMargin: CGFloat = 4
    static let imgBottomMargin: CGFloat = 4

    var imgListView: UIView? = nil
    var imgViewArray: [UIImageView] = []
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        let e = d as! Event
        let lineCount = ceil(CGFloat(e.imageURLList.count) / imageCountIn1Line)
        return lineCount * imageViewWidth + imgTopMargin + imgBottomMargin
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
        imgListView = UIView(frame: CGRect(x: margin, y: DetailImageCell.imgTopMargin, width: 99999, height: 99999))
        contentView.addSubview(imgListView!)

        let e = d as! Event
        var pos: Int = 0
        var line: Int = 0
        var index: Int = 0
        for imgUrl in e.imageURLList {
            let v = createImageView(url: imgUrl, index: index)
            imgListView!.addSubview(v)
            let f = v.frame
            v.frame = CGRect(
                x: CGFloat(pos) * f.width,
                y: CGFloat(line) * f.height,
                width: f.width,
                height: f.height
            )

            pos += 1
            if pos >= Int(DetailImageCell.imageCountIn1Line) {
                pos = 0
                line += 1
            }
            index += 1
        }
    }

    func createImageView(url: String, index: Int) -> UIView {
        let v = UIView()
        v.bounds = CGRect(x: 0, y: 0, width: DetailImageCell.imageViewWidth, height: DetailImageCell.imageViewWidth)

        //添加图片
        let imgWidth = DetailImageCell.imageViewWidth - 2 * DetailImageCell.imgMargin
        let img = UIImageView(frame: CGRect(x: DetailImageCell.imgMargin, y: DetailImageCell.imgMargin, width: imgWidth, height: imgWidth))
        v.addSubview(img)

        img.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "img_default"))

        v.tag = index
        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailImageCell.tapImageView(ges:)))
        v.addGestureRecognizer(tap)

        let longP = UILongPressGestureRecognizer(target: self, action: #selector(DetailImageCell.longPressImageView(ges:)))
        v.addGestureRecognizer(longP)

        imgViewArray.append(img)

        return v
    }

    func tapImageView(ges: UITapGestureRecognizer) {
        print("tapImageView")
        let index = ges.view!.tag

        var skImgArray: [SKPhoto] = []
        for imgV in imgViewArray {
            if let img = imgV.image {
                let photo = SKPhoto.photoWithImage(img)
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
        UITools.showAlert(ctrlr, title: "删除图片", msg: "您确定要删除这张图片吗？", type: 2) { _ in
            print("confirm to delete")
            let detailCtrlr = self.ctrlr as! DetailViewController
            let cellIndex = detailCtrlr.tableView.indexPath(for: self)
            detailCtrlr.changeEvent(cellIndex!, changeType: "C") { event in
                event.imageURLList.remove(at: index)
            }
        }
    }
}

