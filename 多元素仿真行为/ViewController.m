//
//  ViewController.m
//  多元素仿真行为
//
//  Created by 王奥东 on 16/3/31.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)UIView *bigHead;
@property(nonatomic,strong)UIAttachmentBehavior *attach;
@property(nonatomic,strong)UIDynamicAnimator *animate;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *ballArarrys = [NSMutableArray array];
    
    for (int i =0; i<9; i++) {
        
        UIView *ball = [[UIView alloc]initWithFrame:CGRectMake(i*20, 20, 20, 20)];
        ball.layer.cornerRadius = 10;
        ball.layer.masksToBounds = YES;
        if (i==8) {
            ball.frame = CGRectMake(i*20, 20, 40, 40);
            ball.layer.cornerRadius = 20;
            ball.layer.masksToBounds = YES;
            
            self.bigHead = ball;
        }
        ball.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:0.8];
        [self.view addSubview:ball];
        [ballArarrys addObject:ball];
    
    }
    
    self.animate =[[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
//    self.animate = animate;
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:ballArarrys];
    
    [_animate addBehavior:gravity];
    
    UICollisionBehavior *collison = [[UICollisionBehavior alloc]initWithItems:ballArarrys];
    collison.translatesReferenceBoundsIntoBoundary = YES;
    [_animate addBehavior:collison];
    
    for (int i=0; i<8; i++) {
        UIAttachmentBehavior *attach = [[UIAttachmentBehavior alloc]initWithItem:ballArarrys[i] attachedToItem:ballArarrys[i+1]];
        [_animate addBehavior:attach];
    }
  
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    
    [self.view addGestureRecognizer:pan];
    
}
-(void)pan:(UIPanGestureRecognizer *)panGesture{
    
    CGPoint loc = [panGesture locationInView:panGesture.view];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
        UIAttachmentBehavior *attach = [[UIAttachmentBehavior alloc]initWithItem:self.bigHead attachedToAnchor:loc];
        [self.animate addBehavior:attach];
        
        self.attach = attach;
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        
        self.attach.anchorPoint = loc;
    }else if (panGesture.state == UIGestureRecognizerStateEnded){
        [self.animate removeBehavior:self.attach];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
