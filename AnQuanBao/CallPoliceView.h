//
//  CallPoliceViewController.h
//  AnQuanBao
//
//  Created by yyfwptz on 2017/6/14.
//  Copyright © 2017年 yyfwptz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol cpDelegate<NSObject>
-(void)slideUp;
-(void)slideDown;
-(void)callPolice;
-(void)answer;
@end

@interface CallPoliceView : UIView{
    id<cpDelegate> delegate;
}
@property (strong, nonatomic) IBOutlet UIView *CP;
@property (strong, nonatomic) IBOutlet UIButton *CPbtn;
@property (strong, nonatomic) id<cpDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *locationbtn;
@end
