//
//  LO_LanOuViewController.m
//  LocationMap
//
//  Created by CXY on 15-7-28.
//  Copyright (c) 2014年 www.lanou3g.com 北京蓝欧科技有限公司. All rights reserved.
//

#import "LO_LanOuViewController.h"

@interface LO_LanOuViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *lanouWebView;

@end

@implementation LO_LanOuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"蓝鸥3G学院";
    
    [self.lanouWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.lanou3g.com"]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
