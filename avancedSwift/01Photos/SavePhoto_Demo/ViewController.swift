//
//  ViewController.swift
//  SavePhoto_Demo
//
//  Created by apple on 17/4/14.
//  Copyright © 2017年 DWade. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    //存放照片资源的标志符
    var localId:String!
    override func viewDidLoad() {
        super.viewDidLoad()
  
        let fileURL: String! = Bundle.main.path(forResource: "beauty", ofType: "jpg")
        
        let newImage = UIImage(contentsOfFile: fileURL!)
        self.imageView.image = newImage
        
        //保存相片
//        self.savePhoto(image: newImage!)
        //获取相册
//        self.getAlbum()
        
        //获取用户创建的相册
//        self.fetchAllUserCreatedAlbum()
        //创建相册
//        self.createAssetCollection()
        
        //删除特定相册
//        let topLevelUserCollections:PHFetchResult = PHCollectionList.fetchTopLevelUserCollections(with: nil)
//        
//        self.deleteAssetCollection(collectionList: topLevelUserCollections)
    }

    //删除特定的相册(Requests to delete the specified asset collections)
    func deleteAssetCollection(collectionList: PHAssetCollection) {
        PHPhotoLibrary.shared().performChanges({ 
            PHAssetCollectionChangeRequest.deleteAssetCollections(collectionList as! NSFastEnumeration)
        }) { (isSuccess, error) in
            if !isSuccess {print("删除相册成功\(collectionList)")}else {print("删除失败")}
        }
    }
    //创建自定义相册
    func createAssetCollection() -> Void{

        PHPhotoLibrary.shared().performChanges({ 
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "我是韦德")
        }) { (isSuccess: Bool, error) in
            if !isSuccess { print("error creating assetCollection: \(error)") }
            else {print("成功了")}
            //use the PHObjectPlaceholder object provided by the change request. After the change block completes, use the placeholder object’s localIdentifier property to fetch the created object.
        }
    }
    
    
    func savePhoto(image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            
            // Request creating an asset from the image.
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)

            let assetPlaceholder = creationRequest.placeholderForCreatedAsset
            //保存标志符
            self.localId = assetPlaceholder?.localIdentifier
            
        }, completionHandler: { success, error in
            if !success { print("error creating asset: \(error)") }
            else {
                print("成功了")
            
                //通过标志符获取对应的资源
                let assetResult = PHAsset.fetchAssets(
                    withLocalIdentifiers: [self.localId], options: nil)
                let asset = assetResult[0]
                let options = PHContentEditingInputRequestOptions()
                options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData)
                    -> Bool in
                    return true
                }
                //获取保存的图片路径
                asset.requestContentEditingInput(with: options, completionHandler: {
                    (contentEditingInput:PHContentEditingInput?, info: [AnyHashable : Any]) in
                    print("地址：",contentEditingInput!.fullSizeImageURL!)
                })
                

            
            }
        })
    }
    
    // 列出所有相册智能相册
    func getAlbum() {

        let smartAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        print("智能\(smartAlbums.count)个")
        // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
        for index in 0..<smartAlbums.count {
            //获取一个相册(PHAssetCollection)
            let collection = smartAlbums[index]
            if collection.isKind(of: PHAssetCollection.classForCoder()) {
                //赋值
                let assetCollection = collection
                
                //从每一个智能相册获取到的PHFetchResult中包含的才是真正的资源(PHAsset)
                let assetsFetchResults:PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
                
                print("\(assetCollection.localizedTitle)相册,共有照片数:\(assetsFetchResults.count)")
                
                assetsFetchResults.enumerateObjects({ (asset, i, nil) in
                    //获取每一个资源(PHAsset)
                    print("\(asset)")


                    
                })
            }
        }
        

    }
    
    //2、列出用户创建的相册，并获取每一个相册中的PHAsset对象
    func fetchAllUserCreatedAlbum() {
        
        
        let momentAlbum:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .moment, subtype: .albumRegular, options: nil)
        print("momentAlbum:\(momentAlbum.count)个")
        
        for i in 0..<momentAlbum.count {
            let collection = momentAlbum[i]
            if collection.isKind(of: PHAssetCollection.classForCoder()) {
                //赋值
                let assetCollection = collection
                
                //从每一个智能相册中获取到的PHFetchResult中包含的才是真正的资源(PHAsset)
                let assetsFetchResults:PHFetchResult = PHAsset.fetchAssets(in: assetCollection , options: nil)
                
                print("\(assetCollection.localizedTitle)相册，共有照片数:\(assetsFetchResults.count)")
                
                assetsFetchResults.enumerateObjects({ (asset, i, nil) in
                    print("\(asset)")
                })

            }else {
                assert(false, "error")
            }
            
        }
        
        let topLevelUserCollections:PHFetchResult = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        //topLevelUserCollections中保存的是各个用户创建的相册对应的PHAssetCollection
        print("用户创建\(topLevelUserCollections.count)个")
        
        for i in 0..<topLevelUserCollections.count {
            //获取一个相册
            let collection = topLevelUserCollections[i]
            if collection.isKind(of: PHAssetCollection.classForCoder()) {
                //赋值
                let assetCollection = collection
                
                //从每一个智能相册中获取到的PHFetchResult中包含的才是真正的资源(PHAsset)
                let assetsFetchResults:PHFetchResult = PHAsset.fetchAssets(in: assetCollection as! PHAssetCollection, options: nil)
                
                print("\(assetCollection.localizedTitle)相册，共有照片数:\(assetsFetchResults.count)")
                //遍历自定义相册，存储相片
                if assetCollection.localizedTitle == "HiWade" {
                    self.savePhoto(image: self.imageView.image!, album: assetCollection as! PHAssetCollection)
                }

                assetsFetchResults.enumerateObjects({ (asset, i, nil) in
                    print("\(asset)")
                })
            }
        }
        
        print("所有资源的集合，按时间排序：\(self .getAllSourceCollection())")
        
        
    }
    
    //3、获取所有资源的集合，并按资源的创建时间排序
    func getAllSourceCollection() -> Array<PHAsset>{
        let options:PHFetchOptions = PHFetchOptions.init()
        var assetArr = [PHAsset]()
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        let assetFetchResults:PHFetchResult = PHAsset.fetchAssets(with: options)
        for i in 0..<assetFetchResults.count {
            //获取一个资源(PHAsset)
            let asset = assetFetchResults[i]
//                self.getAssetOrigin(asset: asset)
                self.getAssetThumbnail(asset: assetFetchResults[assetFetchResults.count-1])
            

            //添加到数组
            assetArr.append(asset)
        }
        return assetArr
    }
    
    //4、获取缩略图方法
    func getAssetThumbnail(asset:PHAsset) -> Void {
        
        //获取缩略图
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions() //可以设置图像的质量、版本、也会有参数控制图像的裁剪
        //返回一个单一结果，返回前会堵塞线程，默认是false
        option.isSynchronous = true
        
        manager.requestImage(for: asset, targetSize: CGSize.init(width: 100, height: 200), contentMode: .aspectFit, options: option) { (thumbnailImage, info) in
            print("缩略图:\(thumbnailImage),图像信息：\(info)")
            self.imageView.image = thumbnailImage;
            }
        }

    
    //5、获取原图的方法
    func getAssetOrigin(asset:PHAsset) -> Void {
        
        //获取原图
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions() //可以设置图像的质量、版本、也会有参数控制图像的裁剪
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize:PHImageManagerMaximumSize, contentMode: .aspectFit, options: option) { (originImage, info) in
            self.imageView.image = originImage;
            print("原图:\(originImage),图像信息：\(info)")
        }
    }
    
    
    //保存照片到相册
    func savePhoto(image: UIImage, album: PHAssetCollection) {
        PHPhotoLibrary.shared().performChanges({
            
            /*
             let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
             let assetPlaceholder = result.placeholderForCreatedAsset
             //保存标志符
             self.localId = assetPlaceholder?.localIdentifier
             
             */
            
            
            // Request creating an asset from the image.
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            //            // Request editing the album.
            guard let addAssetRequest = PHAssetCollectionChangeRequest(for: album) else { return }
            let assetPlaceholder = creationRequest.placeholderForCreatedAsset
            //保存标志符
            self.localId = assetPlaceholder?.localIdentifier
            
            // Get a placeholder for the new asset and add it to the album editing request.
            addAssetRequest.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
        }, completionHandler: { success, error in
            if !success
            {
                print("error creating asset: \(error)")
            
            }
            else {
                print("添加到自定义相册成功了")
                
            }

        })
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

