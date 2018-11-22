//
//  ViewController.m
//  tangar
//
//  Created by Murphy Zheng on 2018/4/26.
//

#import "ARViewController.h"
#import "imageHandle.h"
#import "OpenGLView.h"

@implementation ARViewController {
    OpenGLView *glView;
}

- (void)loadView {
    self->glView = [[OpenGLView alloc] initWithFrame:CGRectZero];
    self.view = self->glView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self->glView setOrientation:self.interfaceOrientation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self->glView start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self->glView stop];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self->glView resize:self.view.bounds orientation:self.interfaceOrientation];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self->glView setOrientation:toInterfaceOrientation];
}
- (IBAction)scan:(UIButton *)sender {
    
}

@end
