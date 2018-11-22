//
//  imageHandle.m
//  helloarvideo
//
//  Created by Murphy Zheng on 2018/4/26.
//

#import "ImageHandle.h"

@implementation ImageHandle
{
    NSURLSessionTask *_downloadTask;
}

- (BOOL)isFileExist:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"文件%@%@", filePath, result?@"已存在":@"不存在");
    return result;
}

@end
