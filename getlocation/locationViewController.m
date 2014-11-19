//
//  locationViewController.m
//  St.Petersburg
//
//  Created by beginner on 14-11-18.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "locationViewController.h"
#define minUnit 0.0002

@interface locationViewController ()
{
    CLLocationManager *locationManager;
    UIButton *noNetButton;
    UITableView *locationTV;
    NSMutableArray *cityArr;
    NSMutableArray *raingeArr;
    CLGeocoder *locGeocoder;
}

@end

@implementation locationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setNewTitle:@"所在位置"];
    hideTabbar
}

backButton


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self connNet];
    [self addtableView];
}

- (void)addtableView
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cityArr = [[NSMutableArray alloc]init];
    raingeArr = [[NSMutableArray alloc]init];
    locGeocoder = [[CLGeocoder alloc]init];

    locationTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
//    locationTV.dataSource = self;
//    locationTV.delegate = self;
    [self.view addSubview:locationTV];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;    
}

NetChange(noNetButton)
GO_NET
- (void)connNet
{
    noNetButton=NoNetButton(noNetButton);
    
    Reachability*rea2 =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([rea2  currentReachabilityStatus]==NotReachable)
    {
        noNetButton.hidden=NO;
    }
    else
    {
        noNetButton.hidden=YES;
    }
    
    //获取我的位置
    locationManager=[[CLLocationManager alloc]init];
    if ([CLLocationManager locationServicesEnabled]==YES)
    {
        //                NSLog(@"ok");
    }
    else
    {
        //                NSLog(@"创造一个警告框,告诉用户去设置里面开启定位服务");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您好，请先打开位置定位！" delegate:self cancelButtonTitle:@"好的，谢谢" otherButtonTitles: nil];
        [alert show];
    }
    //精确度
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //更新位置的范围
    [locationManager setDistanceFilter:100.f];
    
    locationManager.delegate=self;
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location=[locations lastObject];
    
    CLLocation *thelocation = [[CLLocation alloc]initWithLatitude:location.coordinate.latitude - 0.0030 longitude:location.coordinate.longitude + 0.0051]; //位置反编码
    
    
    
    [locGeocoder reverseGeocodeLocation:thelocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         for (CLPlacemark *placemake in placemarks)
         {
//             NSLog(@"placemake.name = %@",placemake.name);
             [raingeArr addObject:placemake.name];
             [cityArr addObject:placemake.locality];
//             UILabel *label = (UILabel *)[self.view viewWithTag:100];
//             label.frame = CGRectMake(35, 0, 260, 40);
//             label.font = [UIFont systemFontOfSize:15.5];
//             label.text = placemake.name;
//             if (placemake.name.length > 16)
//             {
//                 label.frame = CGRectMake(35, 0, 200, 40);
//                 label.font = [UIFont systemFontOfSize:13];
//                 label.text = placemake.name;
//             }
//             if (placemake.name.length >= 30)
//             {
//                 label.frame = CGRectMake(35, 0, 250, 40);
//                 label.font = [UIFont systemFontOfSize:13];
//                 label.text = placemake.name;
//             }
//             label.numberOfLines = 0;
         }
     }];
    
    for (NSInteger i = 1; i <= 10; i ++)
    {
        //经纬度加 一个 单位
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:thelocation.coordinate.latitude + i * minUnit longitude:thelocation.coordinate.longitude];
        [self Getlocation:loc];
        
        loc = [[CLLocation alloc]initWithLatitude:thelocation.coordinate.latitude  longitude:thelocation.coordinate.longitude + i * minUnit];
        [self Getlocation:loc];

        loc = [[CLLocation alloc]initWithLatitude:thelocation.coordinate.latitude + i * minUnit  longitude:thelocation.coordinate.longitude + i * minUnit];
        [self Getlocation:loc];
        
        //经纬度减 一个 单位
        loc = [[CLLocation alloc]initWithLatitude:thelocation.coordinate.latitude - i * minUnit longitude:thelocation.coordinate.longitude];
        [self Getlocation:loc];
        
        loc = [[CLLocation alloc]initWithLatitude:thelocation.coordinate.latitude  longitude:thelocation.coordinate.longitude - i * minUnit];
        [self Getlocation:loc];
        
        loc = [[CLLocation alloc]initWithLatitude:thelocation.coordinate.latitude - i * minUnit  longitude:thelocation.coordinate.longitude - i * minUnit];
        [self Getlocation:loc];
    }
    NSLog(@"cityArr = %@",cityArr);
    NSLog(@"raingeArr = %@",raingeArr);
    
    [locationManager stopUpdatingLocation];
}


- (void)Getlocation:(CLLocation *)location
{

    //位置反编码    
    [locGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
//         NSLog(@"%@",placemarks);
         for (CLPlacemark *placemake in placemarks)
         {
//             NSLog(@"a==%@",placemake.name);
             [raingeArr addObject:placemake.name];
//             NSLog(@"b==%@",placemake.thoroughfare);
//             NSLog(@"c==%@",placemake.subThoroughfare);
//             NSLog(@"d==%@",placemake.locality);
             [cityArr addObject:placemake.locality];
//             NSLog(@"e==%@",placemake.subLocality);
//             NSLog(@"f==%@",placemake.administrativeArea);
//             NSLog(@"g==%@",placemake.subAdministrativeArea);
//             NSLog(@"h==%@",placemake.postalCode);
//             NSLog(@"i==%@",placemake.ISOcountryCode);
//             NSLog(@"j==%@",placemake.country);
//             NSLog(@"k==%@",placemake.inlandWater);
//             NSLog(@"l==%@",placemake.ocean);
//             NSLog(@"m==%@",placemake.areasOfInterest);
         }
     }];

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
