//
//  ViewController.m
//  AnQuanBao
//
//  Created by yyfwptz on 2017/6/14.
//  Copyright © 2017年 yyfwptz. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "CallPoliceView.h"
#import "CPInfo.h"
#import "JSONKit.h"

@interface BMKSportNode : NSObject

//经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//方向（角度）
@property (nonatomic, assign) CGFloat angle;
//距离
@property (nonatomic, assign) CGFloat distance;
//速度
@property (nonatomic, assign) CGFloat speed;

@end

@implementation BMKSportNode

@synthesize coordinate = _coordinate;
@synthesize angle = _angle;
@synthesize distance = _distance;
@synthesize speed = _speed;

@end

@interface SportAnnotationView : BMKAnnotationView

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SportAnnotationView

@synthesize imageView = _imageView;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 22.f, 22.f)];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 22.f, 22.f)];
        _imageView.image = [UIImage imageNamed:@"sportarrow.png"];
        [self addSubview:_imageView];
    }
    return self;
}

@end


@interface ViewController ()

@end

@implementation ViewController
CallPoliceView *cp;
CLLocationDegrees latitude;
CLLocationDegrees longitude;
NSMutableArray *sportNodes;//轨迹点
NSInteger sportNodeNum;//轨迹点数
NSInteger currentIndex;//当前结点
BMKPointAnnotation *sportAnnotation;
BMKPointAnnotation* pointAnnotation;
BMKPolygon *pathPloygon;
SportAnnotationView *sportAnnotationView;
- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:_mapView];
    //    CDVViewController *cdvController = [[CDVViewController alloc]init];
    //    [self.navigationController pushViewController:cdvController animated:YES];
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    _locService.distanceFilter = 10.0f;
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    
    cp = [[CallPoliceView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 290)];
    cp.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width - 40, 200);
    cp.delegate = self;
    [self.view addSubview:cp];
   // [self showLocation];
//    sportNodes = [[NSMutableArray alloc] init];
    
    
}

-(void)slideUp {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    cp.frame= CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width - 40, 200);
    [UIView commitAnimations];
}

-(void)slideDown{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    cp.frame= CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width - 40, 200);
    [UIView commitAnimations];
}

-(void)answer{
    sportNodes = [[NSMutableArray alloc] init];

    static dispatch_source_t _timer;
    NSTimeInterval period = 5.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger *index = 1;
            NSString *url = [@"http://192.168.1.122:3000/location/" stringByAppendingString: [NSString stringWithFormat: @"%d", index]];
//            NSURL * url = [NSURL URLWithString:@"http://192.168.1.122:3000/location"];
            NSLog(@"url:%@", url);
            NSURLSession * session = [NSURLSession sharedSession];
            NSURLSessionDataTask * task = [session dataTaskWithURL:url
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                                                     NSLog(@"data%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                     if (data) {
                                                         NSArray *arr2 = [data objectFromJSONData];
                                                         for (NSDictionary *dic in arr2) {
                                                             BMKSportNode *sportNode = [[BMKSportNode alloc] init];
                                                             sportNode.coordinate = CLLocationCoordinate2DMake([dic[@"lat"] doubleValue], [dic[@"lon"] doubleValue]);
                                                             sportNode.angle = [dic[@"angle"] doubleValue];
                                                             sportNode.distance = [dic[@"distance"] doubleValue];
                                                             sportNode.speed = [dic[@"speed"] doubleValue];
                                                             [sportNodes addObject:sportNode];
                                                             sportNodeNum = sportNodes.count;
                                                             
                                                         }
                                                     }
                                                     
                                                 }];
            index++;
            [task resume];
        });
    });
    dispatch_resume(_timer);
}

-(void)callPolice{
    
    
    static dispatch_source_t _timer;
    NSTimeInterval period = 5.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:@"http://192.168.1.122:3000/location"];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
            request.HTTPMethod = @"POST";
            NSString *la = [@"distance=100&lat=" stringByAppendingString:[NSString stringWithFormat:@"%lf",latitude]];
            NSString *lo = [@"&lon=" stringByAppendingString:[NSString stringWithFormat:@"%lf",longitude]];
            request.HTTPBody = [[la stringByAppendingString:lo] dataUsingEncoding:NSUTF8StringEncoding];
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSLog(@"data%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            }] resume];

        });
    });
    dispatch_resume(_timer);
    
//    static dispatch_source_t _timer;
//    NSTimeInterval period = 5.0; //设置时间间隔
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//           
////            NSURL * url = [NSURL URLWithString:@"http://192.168.1.122:3000/location"];
////            NSURLSession * session = [NSURLSession sharedSession];
////            NSURLSessionDataTask * task = [session dataTaskWithURL:url
////                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
////                                                     NSLog(@"data%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
////                                                     NSURLRequest *request2 = [NSURLRequest requestWithURL:url];
////                                                     [[[NSURLSession sharedSession] dataTaskWithRequest:request2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
////                                                         if (data && !error) {
////                                                             id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
////                                                             pointAnnotation = [[BMKPointAnnotation alloc]init];
////                                                             CLLocationCoordinate2D coor;
////                                                             coor.latitude = [obj[@"lat"] doubleValue];
////                                                             coor.longitude = [obj[@"lon"] doubleValue];
////                                                             pointAnnotation.coordinate = coor;
////                                                         }
////                                                     }] resume];
////                                                     
////                                                 }];
////            [_mapView addAnnotation:pointAnnotation];
////            [task resume];
//            
//            
////            sportNodes = [[NSMutableArray alloc] init];
////            //读取数据
//            NSURL * url = [NSURL URLWithString:@"http://192.168.1.122:3000/location"];
//           
//            NSURLSession * session = [NSURLSession sharedSession];
//            NSURLSessionDataTask * task = [session dataTaskWithURL:url
//                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                                                     NSLog(@"data%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//                                                     if (data) {
//                                                         NSArray *arr2 = [data objectFromJSONData];
//                                                         for (NSDictionary *dic in arr2) {
//                                                             BMKSportNode *sportNode = [[BMKSportNode alloc] init];
//                                                             sportNode.coordinate = CLLocationCoordinate2DMake([dic[@"lat"] doubleValue], [dic[@"lon"] doubleValue]);
////                                                           sportNode.angle = [dic[@"angle"] doubleValue];
//                                                             sportNode.distance = [dic[@"distance"] doubleValue];
//                                                             sportNode.speed = [dic[@"speed"] doubleValue];
//                                                             [sportNodes addObject:sportNode];
//                                                             sportNodeNum = sportNodes.count;
//                                                             
//                                                         }
////                                                         NSLog(@"sportNodeNum:%ld",(long)sportNodeNum);
//                                                     }
//                                                     
//                                                 }];
//            [task resume];
//        });
//    });
//    
//    // 开启定时器
//    dispatch_resume(_timer);
    
    // 关闭定时器
    // dispatch_source_cancel(_timer);
}

- (void)start {
    CLLocationCoordinate2D paths[sportNodeNum];
    for (NSInteger i = 0; i < sportNodeNum; i++) {
        BMKSportNode *node = sportNodes[i];
        paths[i] = node.coordinate;
    }
    
    pathPloygon = [BMKPolygon polygonWithCoordinates:paths count:sportNodeNum];
    //    [_mapView addOverlay:pathPloygon];
    
    sportAnnotation = [[BMKPointAnnotation alloc]init];
    sportAnnotation.coordinate = paths[0];
    sportAnnotation.title = @"test";
    [_mapView addAnnotation:sportAnnotation];
    currentIndex = 0;
}

- (void)running {
    BMKSportNode *node = [sportNodes objectAtIndex:currentIndex];
    sportAnnotationView.imageView.transform = CGAffineTransformMakeRotation(node.angle);
    [UIView animateWithDuration:node.distance/node.speed animations:^{
        if(currentIndex < sportNodeNum - 1){
            currentIndex++;
            BMKSportNode *node = [sportNodes objectAtIndex:currentIndex];
            sportAnnotation.coordinate = node.coordinate;
        }else{
            return;
        }
    } completion:^(BOOL finished) {
        [self running];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    
}

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    [self start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    [_mapView updateLocationData:userLocation];
    
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    [self running];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"didUpdateUserLocation lat %f,long %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    latitude = userLocation.location.coordinate.latitude;
    longitude = userLocation.location.coordinate.longitude;
    [_mapView updateLocationData:userLocation];
    _mapView.centerCoordinate = userLocation.location.coordinate;
    [_mapView setZoomLevel:20];
    [_locService stopUserLocationService];
    
}


- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0.5 blue:0.0 alpha:0.6];
        polygonView.lineWidth = 3.0;
        return polygonView;
    }
    return nil;
}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if (sportAnnotationView == nil) {
        sportAnnotationView = [[SportAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"sportsAnnotation"];
        
        
        sportAnnotationView.draggable = NO;
        BMKSportNode *node = [sportNodes firstObject];
        sportAnnotationView.imageView.transform = CGAffineTransformMakeRotation(node.angle);
        
    }
    return sportAnnotationView;
}




@end
