//
//  CPInfo.m
//  AnQuanBao
//
//  Created by yyfwptz on 2017/6/15.
//  Copyright © 2017年 yyfwptz. All rights reserved.
//

#import "CPInfo.h"

@implementation CPInfo

-(void)setUsername:(NSString *)username {
    userName = username;
}

-(NSString *)userName {
    return userName;
}

-(void)setLatitude:(NSString *)lat {
    latitude = lat;
}

-(NSString *)latitude {
    return latitude;
}

-(void)setLongitude:(NSString *)lon {
    longitude = lon;
}

-(NSString *)longitude {
    return longitude;
}

-(void)setContact:(NSString *)con {
    contact = con;
}

-(NSString *)contact {
    return contact;
}
@end
