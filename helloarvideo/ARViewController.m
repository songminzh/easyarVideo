//
//  ViewController.m
//  greattang
//
//  Created by Murphy Zheng on 2018/6/6.
//  Copyright © 2018年 Mieasy. All rights reserved.
//

#import "ARViewController.h"
#import "imageHandle.h"
#import "Masonry.h"
#import "OpenGLView.h"
#import "GTDefine.h"
#import <easyar/engine.oc.h>

@implementation ARViewController {
    OpenGLView *glView;
}

#pragma mark  - Life Circle

- (instancetype)init {
    self = [super init];
    if (self) {
        DebugLog(@"AR Init");
    }
    return self;
}

- (void)loadView {
    glView = [[OpenGLView alloc] initWithFrame:CGRectZero];
    self.view = glView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [glView setOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [glView start];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [glView resize:self.view.bounds orientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [glView stop];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    
}

- (void)initNav {
    // Use Mansonry
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [glView addSubview:leftItem];
    [leftItem setTitle:@"Back" forState:UIControlStateNormal];
    leftItem.enabled = YES;
    [leftItem addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    CGRect left_rect = CGRectMake(0, 14, 80, 30);
    [leftItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->glView.mas_top).with.offset(left_rect.origin.y);
        make.left.equalTo(self->glView.mas_left).with.offset(left_rect.origin.x);
        make.width.mas_equalTo(left_rect.size.width);
        make.height.mas_equalTo(left_rect.size.height);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"AR Scan";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [glView addSubview:titleLabel];
    CGRect title_rect = CGRectMake((SCREEN_WIDTH - 90)/2, 14, 90, 30);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->glView.mas_top).with.offset(title_rect.origin.y);
        make.left.mas_equalTo(self->glView.mas_left).with.offset(title_rect.origin.x);
        make.width.with.mas_equalTo(title_rect.size.width);
        make.height.with.mas_equalTo(title_rect.size.height);
    }];
    
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItem setTitle:@"Flash" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [glView addSubview:rightItem];
    CGRect right_rect = CGRectMake(SCREEN_WIDTH - 80, 14, 80, 30);
    [rightItem addTarget:self action:@selector(flashSwith) forControlEvents:UIControlEventTouchUpInside];
    [rightItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->glView.mas_top).with.offset(right_rect.origin.y);
        make.left.mas_equalTo(self->glView.mas_left).with.offset(right_rect.origin.x);
        make.width.mas_equalTo(right_rect.size.width);
        make.height.mas_equalTo(right_rect.size.height);
    }];
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)flashSwith {
    // TODO: 打开闪光灯
}

@end
