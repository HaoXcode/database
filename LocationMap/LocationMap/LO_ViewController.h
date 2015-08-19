//
//  LO_ViewController.h
//  LocationMap
//
//  Created by CXY on 15-7-28.
//  Copyright (c) 2014年 www.lanou3g.com 北京蓝欧科技有限公司. All rights reserved.
//
/**
 * 定位  地图显示
 *
 * @since <#1.0#>
 */

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LO_ViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@end
