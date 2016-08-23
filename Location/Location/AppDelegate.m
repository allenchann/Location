//
//  AppDelegate.m
//  Location
//
//  Created by allen_Chan on 16/8/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<CLLocationManagerDelegate>

{
    CLLocationManager *_locationManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    _locationManager = [[CLLocationManager alloc] init];
    
    //设置代理
    
    _locationManager.delegate = self;
    
    //询问用户，获得权限。会有一个弹窗，询问用户是否允许app获取当前地理位置
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
    }
    else
        [_locationManager requestWhenInUseAuthorization];
    
    [_locationManager startUpdatingLocation];
    
    

    
    CLGeocoder *coder = [[CLGeocoder alloc]init];
    NSString *str = @"中国广东省广州市天河区天园街道中山大道西";
    //编码器开始编码,在返回的块中进行操作.
    [coder geocodeAddressString:str completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //判断是否编码出错
        if (error) {
            NSLog(@"%@",error);
        }
        else
        {
            //从解析的数据中获取到位置信息
            CLPlacemark *myPlace = [placemarks lastObject];
            CLLocation *location = myPlace.location;
            //编码器进行反地理编码,在返回的块中进行操作.
            [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                if (!error)
                {
                    //从解析的数据中获取到位置信息
                    CLPlacemark *place = [placemarks lastObject];
                    NSLog(@"%@",place.addressDictionary);
                }
                else
                    NSLog(@"%@",error);
                
            }];
        }
    }];
    
    
    return YES;
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}
//定位完成
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
//    NSLog(@"%@",locations);
    NSLog(@"%f,%f",location.coordinate.longitude,location.coordinate.latitude);
    
    
    [manager stopUpdatingLocation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
