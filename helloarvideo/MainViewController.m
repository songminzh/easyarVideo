//
//  MainViewController.m
//  greatetang
//
//  Created by Murphy Zheng on 2018/4/27.
//  Copyright © 2018年 Mieasy. All rights reserved.
//

#import "MainViewController.h"
#import "ARViewController.h"
#import "ImageHandle.h"
#import "AFNetworking.h"
#import "ProgressHUD.h"
#import "SSZipArchive.h"
#import "MBProgressHUD.h"

static NSString *kTargetImagesFileName = @"/targets";
static NSString *kTargetFileURLString  = @"http://oprnxh1p7.bkt.clouddn.com/targets.zip";

@interface MainViewController (){
    NSURLSessionTask *_downloadTask;
}

@end

@implementation MainViewController

- (IBAction)startScan:(id)sender {
    ImageHandle *imageHandle = [[ImageHandle alloc] init];
    if (![imageHandle isFileExist:kTargetImagesFileName]) {
        [self downloadFileWithURL:[NSURL URLWithString:kTargetFileURLString]];
    }else {
        ARViewController *arVC = [[ARViewController alloc] init];
        [self presentViewController:arVC animated:YES completion:nil];
    }
}

- (void)downloadFileWithURL:(NSURL *)URL {
    // HUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"正在更新资源包……";
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (downloadProgress) {
            CGFloat currentProgress = (CGFloat)(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.progress = currentProgress;
                hud.label.text = [NSString stringWithFormat:@"正在更新资源包:%.0f%%\n",currentProgress * 100];
                NSLog(@"%@",[NSString stringWithFormat:@"当前进度为：%.2f%%",currentProgress * 100]);
            });
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachePath stringByAppendingString:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [hud hideAnimated:YES];
        NSString *zipPath = [filePath path];
        NSFileManager *fileManger = [NSFileManager defaultManager];
        
        NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        // remove
        [fileManger removeItemAtPath:folderPath error:nil];
        [fileManger createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        // unzip
        [SSZipArchive unzipFileAtPath:zipPath toDestination:folderPath];
        
        // scan
        ARViewController *arVC = [[ARViewController alloc] init];
        [self presentViewController:arVC animated:YES completion:nil];
    }];
    [_downloadTask resume];
}

@end
