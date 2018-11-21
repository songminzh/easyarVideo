//
//  imageHandle.m
//  helloarvideo
//
//  Created by Murphy Zheng on 2018/6/6.
//  Copyright © 2018年 Mieasy. All rights reserved.
//

#import "ImageHandle.h"

@implementation ImageHandle
{
    NSURLSessionTask *_downloadTask;
}

- (BOOL)isFileExist:(NSString *)fileName {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documentPath stringByAppendingString:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"文件%@%@",filePath, result ? @"已存在" : @"不存在");
    return result;
}

@end
