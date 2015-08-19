//
//  LO_MyAnnotation.m
//  LocationMap
//
//  Created by CXY on 15-7-28.
//  Copyright (c) 2014年 www.lanou3g.com 北京蓝欧科技有限公司. All rights reserved.
//

#import "LO_MyAnnotation.h"

@implementation LO_MyAnnotation

- (id)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init]) {
        _coordinate = coordinate;
    }
    return self;
}
- (NSString *)title
{
    return _annotationTitle;
}
- (NSString *)subtitle
{
    return _annotationSubtitle;
}

@end
