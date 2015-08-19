//
//  LO_ViewController.m
//  LocationMap
//
//  Created by CXY on 15-7-28.
//  Copyright (c) 2014年 www.lanou3g.com 北京蓝欧科技有限公司. All rights reserved.
//

#import "LO_ViewController.h"
#import "LO_LanOuViewController.h"
#import "LO_MyAnnotation.h"

@interface LO_ViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) MKPinAnnotationView *annotationView;
@property (nonatomic) CLLocationCoordinate2D locationCoordinate2D; // 当前位置经纬度
@property (nonatomic) CLLocationCoordinate2D companyCoordinate2D; // 当前位置经纬度

@property(nonatomic, strong)CLGeocoder *geocoder;
@end

@implementation LO_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //给定公司位置
    self.companyCoordinate2D = CLLocationCoordinate2DMake(40.03049389, 116.34332657);
    
    
    // 在iOS8.0之后定位做出了更改，更改如下
    self.locationManager = [[CLLocationManager alloc] init];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        [self.locationManager requestAlwaysAuthorization];
        // 需要在plist文件中添加默认缺省的字段“NSLocationAlwaysUsageDescription”，这个提示是:“允许应用程序在您并未使用该应用程序时访问您的位置吗？”NSLocationAlwaysUsageDescription对应的值是告诉用户使用定位的目的或者是标记。
        [self.locationManager requestWhenInUseAuthorization];
        // 需要在plist文件中添加默认缺省的字段“NSLocationWhenInUseDescription”，这个时候的提示是:“允许应用程序在您使用该应用程序时访问您的位置吗？”
    }
    self.locationManager.delegate = self;
    //定位的精度选为最好 但是这种模式最费电
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置距离筛选器distanceFilter，下面表示设备至少移动1000米，才通知委托更新
    self.locationManager.distanceFilter = 1000.0f;
    //开始更新位置
    [self.locationManager startUpdatingLocation];
}
#pragma mark-懒加载
-(CLGeocoder *)geocoder
 {
    if (_geocoder==nil) {
    
        _geocoder=[[CLGeocoder alloc]init];
    }
     
     return _geocoder;
}
#pragma mark -
#pragma mark - 我的位置
- (IBAction)myLocation:(id)sender {
    self.mapView.showsUserLocation = YES;
}
#pragma mark - 
#pragma mark - 公司位置
- (IBAction)showCompanyAddress:(id)sender {
    //self.mapView removeAnnotations:<#(NSArray *)#>
    //设置地图中心
    LO_MyAnnotation *ann = [[LO_MyAnnotation alloc] init];
    ann.coordinate = self.companyCoordinate2D;
    ann.annotationTitle = @"金五星商业大厦";
    ann.annotationSubtitle = @"蓝欧科技有限公司";
    //触发viewForAnnotation
    [_mapView addAnnotation:ann];
    //添加多个
    //[mapView addAnnotations]
    //设置显示范围
    MKCoordinateRegion region;
    region.span.latitudeDelta = 0.001;
    region.span.longitudeDelta = 0.001;
    region.center = self.companyCoordinate2D;
    // 设置显示位置(动画)
    [_mapView setRegion:region animated:YES];
    // 设置地图显示的类型及根据范围进行显示
    [_mapView regionThatFits:region];
    self.mapView.showsUserLocation = NO;
}


#pragma mark -
#pragma mark - 导航
- (IBAction)mapNavigation:(id)sender {
    // 起始位置，为当前设备的位置，需要点击我的位置获取
    CLLocationCoordinate2D fromCoordinate = self.locationCoordinate2D;
    
    // 终点位置
    CLLocationCoordinate2D toCoordinate = self.companyCoordinate2D;
    
    //绘制导航路线 从起点到终点
    //为了创建一个方向指南请求，我们需要设置源和目的地，两个地点都是MKMapItem 对象。这些对象都代表地图上的位置，包括它的地点以及一些元数据，比如名称，手机号码和UR
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromCoordinate addressDictionary:nil];
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];

    MKPlacemark *toPlacemark = [[MKPlacemark alloc] initWithCoordinate:toCoordinate addressDictionary:nil];
    MKMapItem *toItem = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
   
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = fromItem;
    request.destination = toItem;
    //如果路由服务器可以找出多条合理的路线，设置YES将会返回所有路线。否则，只返回一条路线。
    request.requestsAlternateRoutes = YES;
    
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             NSLog(@"Error: %@", error);
             if (!self.locationCoordinate2D.longitude || !self.locationCoordinate2D.latitude) {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先给起始位置，也就是当前设备位置(点击我的位置)" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                 [alertView show];
             }
             
         }
         else {
             //绘制路线 只取了第一条路线
             MKRoute *route = response.routes[0];
             [self.mapView addOverlay:route.polyline];
         }
     }];
}



#pragma mark - 
#pragma mark - MKMapViewDelegate
#pragma mark - 当前位置的代理
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //userLocation 用户的经纬度信息 需要取出location属性
    
    //这里因为是使用模拟器 地理反编码有可能反编码不出来  所以我们可以使用一些能反编码出来的假数据测试一下。
    CLLocationDegrees lati = 39.785834;
    CLLocationDegrees longti = 119.406417;
    CLLocation * loca = [[CLLocation alloc]initWithLatitude:lati longitude:longti];

    
    //反地理位置编码  经纬度 -> 地理位址  此处若是反编码失败 用loca 替代userLocaton.location
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        //打印查看找到的所有的位置信息
        /*
         name:名称
     locality:城市
      country:国家
   postalCode:邮政编码
        */
        
        if (error || placemarks.count==0) {
            NSLog(@"error ==== %@",error);
            return ;
        }
        //获取第一个
        CLPlacemark *firstplaceMark = [placemarks firstObject];
        
        CLLocationDegrees latitude = firstplaceMark.location.coordinate.latitude;
        CLLocationDegrees longtitude = firstplaceMark.location.coordinate.longitude;
        NSLog(@"latitude == %.f   longtitude == %.f",latitude,longtitude);
        
        self.showLabel.text = [firstplaceMark.name substringFromIndex:2];
        
    }];
    
    
    //放大地图到设备所在位置，并设置显示的区域的大小，单位是米。
    //实际开发使用中  应该是 lati 应该改为userLocation.location.coordinate.latitude 、longti应该改为 userLocation.location.coordinate.longitude  因为模拟器原因 可能找不到位置 所以手动填的经纬度
    
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(    CLLocationCoordinate2DMake(lati, longti), 200, 200);
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - 大头针的代理方法
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // 如果是当前位置,无需更改
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    if ([annotation isKindOfClass:[LO_MyAnnotation class]])
    {
        
        NSString *annotationViewId=@"cxy";
        _annotationView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewId];
        if (_annotationView==nil){
            // MKAnnotationView是使用自定义的图片.MKPinAnnotationView是定义系统默认的大头针
            _annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewId];
            _annotationView.canShowCallout = YES;
            UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
            leftView.frame = CGRectMake(5, 5, 104, 30);
            _annotationView.leftCalloutAccessoryView = leftView;
            _annotationView.animatesDrop = YES;
            // 设置右按钮
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            _annotationView.rightCalloutAccessoryView = rightButton;
        }
    }
    return _annotationView;
}


// user tapped the disclosure button in the callout
//
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // 点击信息面板触发的操作
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[LO_MyAnnotation class]])
    {
        LO_LanOuViewController *lanouVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"lanouVC"];
        [self.navigationController pushViewController:lanouVC animated:YES];
    }
}


#pragma mark - 导航的代理方法
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    //路线图层
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 5.0; // 线宽
    renderer.strokeColor = [UIColor purpleColor];//线的颜色
    return renderer;
}

#pragma mark - 添加范围图层（自己了解一下）
- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers

{
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
