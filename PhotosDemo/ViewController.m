//
//  ViewController.m
//  PhotosDemo
//
//  Created by deng on 16/11/25.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>

@interface ViewController () <PHPhotoLibraryChangeObserver>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self createAlbum];
    } else {
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            [self createAlbum];
        }];
    }
}

- (void)createAlbum {
    [self AsyncAddAlbumWithName:@"异步相册"];
    if ([self SyncAddAlbumWithName:@"同步相册"]) {
        NSLog(@"同步创建相册成功");
    } else {
        NSLog(@"同步创建相册失败");
    }
}

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)AsyncAddAlbumWithName:(NSString *)name {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name];
    } completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"异步创建相册：%@成功", name);
        } else {
            NSLog(@"异步创建相册：%@失败", name);
        }
    }];
    
    
}

- (BOOL)SyncAddAlbumWithName:(NSString *)name {
    return [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name];
    } error:nil];;
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    NSLog(@"photo library did change");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
