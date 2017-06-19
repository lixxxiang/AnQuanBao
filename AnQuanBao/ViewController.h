//
//  ViewController.h
//  AnQuanBao
//
//  Created by yyfwptz on 2017/6/14.
//  Copyright © 2017年 yyfwptz. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <Cordova/CDVViewController.h>
#import <Cordova/CDVCommandDelegateImpl.h>
#import <Cordova/CDVCommandQueue.h>
#import "CallPoliceView.h"

@interface ViewController :  CDVViewController<BMKMapViewDelegate, BMKLocationServiceDelegate, cpDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService *_locService;
}


@end

