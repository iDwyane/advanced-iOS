//
//  ViewController.m
//  SavePhoto_Demo_OC
//
//  Created by apple on 17/5/2.
//  Copyright © 2017年 DWade. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//存放照片资源的标志符
@property (nonatomic, strong)NSString *localId;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //读取文件
    NSString *fileURL = [[NSBundle mainBundle] pathForResource:@"beauty" ofType:@"jpg"];
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:fileURL];
    self.imageView.image = image;
    //保存图片
//    [self savePhoto:image];
    //获取用户创建的相册
    [self fetchAllUserCreatedAlbum];
}

- (void)savePhoto:(UIImage*)image {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // Request creating an asset from the image.
        PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        // Get a placeholder for the new asset and add it to the album editing request.
        PHObjectPlaceholder *assetPlaceholder = [createAssetRequest placeholderForCreatedAsset];
        //保存标识符
        self.localId = assetPlaceholder.localIdentifier;


    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"error creating asset:%@", error);
        }else {
            NSLog(@"成功了");
            
            //通过标志符获取对应的资源
            PHFetchResult *assetResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[self.localId] options:nil];
            PHAsset *asset = assetResult[0];
            PHContentEditingInputRequestOptions *options;
            [options setCanHandleAdjustmentData:^BOOL(PHAdjustmentData * _Nonnull error) {
                return YES;
            }];
            
            //获取保存的图片路径
            [asset requestContentEditingInputWithOptions:( PHContentEditingInputRequestOptions *)options completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
                NSLog(@"地址：%@", [contentEditingInput fullSizeImageURL]);
            }];
        }
    }];
}

- (void)getAlbum {
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSLog(@"智能%lu", (unsigned long)smartAlbums.count);
    // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
    for (int i = 0; i < smartAlbums.count; i++) {
        //获取一个相册(PHAssetCollection)
        PHAssetCollection *collection = smartAlbums[i];

        if ([collection isKindOfClass: [PHAssetCollection class]]) {
            //赋值
            PHAssetCollection *assetCollection = collection;
            //从每一个智能相册获取到的PHFetchResult中包含的才是真正的资源(PHAsset)
            PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            NSLog(@"%@,相册，共有照片数：%lu",assetCollection.localizedTitle,             (unsigned long)assetsFetchResults.count);
            
            [assetsFetchResults enumerateObjectsUsingBlock:^(id  _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
                //获取每一个资源(PHAsset)
                NSLog(@"%@",asset);
            }];
        }
        
    }
}

- (void)fetchAllUserCreatedAlbum {
//    PHFetchResult *momentAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeMoment subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    NSLog(@"momentAlbum:%lu个",(unsigned long)momentAlbum.count);
//    
//    for (int i = 0; i < momentAlbum.count; i++) {
//        PHAssetCollection *collection = momentAlbum[i];
//        PHAssetCollection *assetColletion = collection;
//        
//        //从每一个智能相册中获取到的PHFetchResult中包含的才是真正的资源(PHAsset)
//        PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:assetColletion options:nil];
//        NSLog(@"%@,相册，共有照片数：%lu",assetColletion.localizedTitle,             (unsigned long)assetsFetchResults.count);
//        
//        [assetsFetchResults enumerateObjectsUsingBlock:^(id  _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
//            //获取每一个资源(PHAsset)
//            NSLog(@"%@",asset);
//        }];
//        
//    }
    
    
    
    
        //topLevelUserCollections中保存的是各个用户创建的相册对应的PHAssetCollection
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        
        for (int i = 0; i < topLevelUserCollections.count; i++) {
            PHAssetCollection *collection = topLevelUserCollections[i];
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                //赋值
                PHAssetCollection *assetCollection = collection;
                PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                NSLog(@"%@,相册，共有照片数：%lu",assetCollection.localizedTitle,             (unsigned long)assetsFetchResults.count);
                //遍历自定义相册，存储相片
                if ([assetCollection.localizedTitle isEqualToString:@"HiWade"]) {
                    NSLog(@"有“HiWade”相册");
                }
            }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
