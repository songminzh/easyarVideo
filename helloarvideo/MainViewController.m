//
//  MainViewController.m
//  helloarvideo
//
//  Created by Murphy Zheng on 2018/4/27.
//  Copyright © 2018年 VisionStar Information Technology (Shanghai) Co., Ltd. All rights reserved.
//

#import "MainViewController.h"
#import "ARViewController.h"
#import "ImageHandle.h"
#import "AFNetworking.h"
#import "ProgressHUD.h"
#import "SSZipArchive.h"
#import "MBProgressHUD.h"

static NSString *kTargetImagesFileName = @"/targets";
@interface MainViewController (){
    NSURLSessionTask *_downloadTask;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startScan:(id)sender {
    ImageHandle *imageHandle = [[ImageHandle alloc] init];
    if (![imageHandle isFileExist:kTargetImagesFileName]) {
        [self downloadFileWithURL:[NSURL URLWithString:@"http://oprnxh1p7.bkt.clouddn.com/targets.zip"]];
    }else {
        ARViewController *arVC = [[ARViewController alloc] init];
        [self presentViewController:arVC animated:YES completion:nil];
    }
}

- (void)downloadFileWithURL:(NSURL *)URL {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *mannager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"正在更新资源包…";
    
    _downloadTask = [mannager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (downloadProgress) {
            CGFloat currentProgress = (CGFloat)downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.progress = currentProgress;
                hud.label.text = [NSString stringWithFormat:@"正在更新资源包:%.0f%%\n",currentProgress * 100];
            });
            
            NSLog(@"%@",[NSString stringWithFormat:@"当前进度为：%.2f%%",currentProgress * 100]);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachePath stringByAppendingString:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [hud hideAnimated:YES];
        
        NSString *imgFilePath = [filePath path];
        NSFileManager *fileManger = [NSFileManager defaultManager];
        NSString *imgaesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        // remove
        [fileManger removeItemAtPath:imgaesPath error:nil];
        [fileManger createDirectoryAtPath:imgaesPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        // unzip
        [SSZipArchive unzipFileAtPath:imgFilePath toDestination:imgaesPath];
        
        // scan
        ARViewController *arVC = [[ARViewController alloc] init];
        [self presentViewController:arVC animated:YES completion:nil];
    }];
    [_downloadTask resume];
}


@end
