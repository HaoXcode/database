//
//  LO_MyAnnotation.h
//  LocationMap
//
//  Created by CXY on 15-7-28.
//  Copyright (c) 2014年 www.lanou3g.com 北京蓝欧科技有限公司. All rights reserved.
//
/**
 * 自定义大头针
 *
 * @param nonatomic <#nonatomic description#>
 *
 * @return <#return value description#>
 *
 * @since <#1.0#>
 */


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LO_MyAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)NSString *annotationTitle;
@property (nonatomic, copy)NSString *annotationSubtitle;
- (id)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate;

@end
