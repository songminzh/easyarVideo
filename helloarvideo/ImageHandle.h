//
//  imageHandle.h
//  helloarvideo
//
//  Created by Murphy Zheng on 2018/6/6.
//  Copyright © 2018年 Mieasy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageHandle : NSObject

/**
 判断文件是否存在
 */
- (BOOL)isFileExist:(NSString *)fileName;

@end
