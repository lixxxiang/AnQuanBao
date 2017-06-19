//
//  CallPoliceViewController.m
//  AnQuanBao
//
//  Created by yyfwptz on 2017/6/14.
//  Copyright © 2017年 yyfwptz. All rights reserved.
//

#import "CallPoliceView.h"

@implementation CallPoliceView
@synthesize delegate;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
UISwipeGestureRecognizer * recognizer;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.CP = [[[NSBundle mainBundle]loadNibNamed:@"CallPoliceView" owner:self options:nil]lastObject];
    self.CP.frame = self.bounds;
    [self addSubview:self.CP];
    [_CPbtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_CPbtn];
    
    [_locationbtn addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self addGestureRecognizer:recognizer];
    
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        [delegate slideDown];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        [delegate slideUp];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
    }
}

-(void)click:(UIButton *)sender {
    [delegate callPolice];
}


-(void)click2:(UIButton *)sender {
    [delegate answer];
}
@end
