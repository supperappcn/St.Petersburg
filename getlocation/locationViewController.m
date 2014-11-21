//
//  locationViewController.m
//  St.Petersburg
//
//  Created by beginner on 14-11-18.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "locationViewController.h"
#import "locationCell.h"

#define minUnit 0.0002

@interface locationViewController ()
{
    CLLocationManager *locationManager;
    UIButton *noNetButton;
    UITableView *locationTV;
    NSMutableArray *cityArr;
    NSMutableArray *raingeArr;
    UISearchBar *searchCity;
    UIActivityIndicatorView *locActivity;
    UILabel *locationL;
    NSMutableArray *reloadCA;
    NSMutableArray *reloadRA;
    BOOL locFlag;
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
    [self addSearchBar];
}

#pragma -mark 添加搜索框
- (void)addSearchBar
{
    searchCity = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchCity.placeholder = @"搜索附近位置";
    searchCity.delegate = self;
    [self.view addSubview:searchCity];
}

#pragma -mark 添加tableView
- (void)addtableView
{
    locFlag = YES;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cityArr = [[NSMutableArray alloc]init];
    raingeArr = [[NSMutableArray alloc]init];
    reloadCA = [[NSMutableArray alloc]init];
    reloadRA = [[NSMutableArray alloc]init];

    locationTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 64 - 44) style:UITableViewStyleGrouped];
    locationTV.dataSource = self;
    locationTV.delegate = self;
    [self.view addSubview:locationTV];
    
    locActivity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(70, 60, 40, 40)];
    locActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [locationTV addSubview:locActivity];
//    [locActivity startAnimating];
    
    locationL = [[UILabel alloc]initWithFrame:CGRectMake(110, 60, 160, 40)];
    locationL.font = [UIFont systemFontOfSize:14.5];
    locationL.text = @"正在搜索附近位置";
    locationL.hidden = YES;
    [locationTV addSubview:locationL];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *index = @"locCell";
    locationCell *cell = [tableView dequeueReusableCellWithIdentifier:index];
    if (cell == nil)
    {
        cell = [[locationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:index];
    }
    if (indexPath.row == 0)
    {
        if (locFlag == YES)
        {
            cell.textLabel.text = @" 不显示位置";
            cell.textLabel.textColor = [UIColor colorWithRed:44.0/255 green:110.0/255 blue:181.0/255 alpha:1];
        }
        else
        {
            cell.textLabel.text = @" 显示位置";
            cell.textLabel.textColor = [UIColor colorWithRed:44.0/255 green:110.0/255 blue:181.0/255 alpha:1];
        }
    }
    else
    {
        if (searchCity.text.length < 1)
        {
            cell.cityL.text = cityArr[indexPath.row - 1];
            cell.raingeL.text = raingeArr[indexPath.row - 1];
        }
        else
        {
            if (reloadRA.count > 0)
            {
                cell.cityL.text = reloadCA[indexPath.row - 1];
                cell.raingeL.text = reloadRA[indexPath.row - 1];
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

#pragma -mark 降下键盘
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchCity resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchCity resignFirstResponder];
}

#pragma -mark 搜索框的文字发生改变的时候
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *result = [NSString stringWithFormat:@"self like[c]'*%@*'",searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:result];
    
    //city
    NSMutableArray *searchCA = (NSMutableArray *)[cityArr filteredArrayUsingPredicate:predicate];
    [reloadRA removeAllObjects];
    for (NSInteger i = 0; i <searchCA.count; i ++)
    {
        NSInteger integ = [cityArr indexOfObject:searchCA[i]];
        NSString *string = raingeArr[integ];
        [reloadRA addObject:string];
    }
    
    //rainge
    NSMutableArray *searchRA = [[NSMutableArray alloc]init];
    [reloadCA removeAllObjects];
    for (NSInteger i = 0; i < raingeArr.count; i ++)
    {
        NSArray *arr = [raingeArr[i] componentsSeparatedByString:searchText];
//        NSLog(@"arr = %@",arr);
        if (arr.count == 1)
        {
            
        }
        else
        {
            [searchRA addObject:raingeArr[i]];
            [reloadCA addObject:cityArr[i]];
        }
    }
    
//    NSLog(@"searchRA = %@",searchRA);
//    NSLog(@"reloadCA = %@",reloadCA);
//    NSLog(@"searchCA = %@",searchCA);
//    NSLog(@"reloadRA = %@",reloadRA);
    
    for (NSInteger i = 0; i <searchCA.count; i ++)
    {
        if ([reloadCA containsObject:searchCA[i]] == NO)
        {
            if (searchRA.count == 0)
            {
               [reloadCA addObjectsFromArray:searchCA];
            }
            else
            {
                [reloadCA addObject:searchCA[i]];
                [searchRA addObject:reloadRA[i]];
            }
        }
    }
    if (searchRA.count != 0)
    {
        [reloadRA addObjectsFromArray:searchRA];
    }

//    NSLog(@"reloadRA = %@",reloadRA);
//    NSLog(@"reloadCA = %@",reloadCA);
    [locationTV reloadData];
}

#pragma -mark 调整活动指示器的高度
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    locActivity.frame = CGRectMake(70, 60 + 47 * cityArr.count, 40, 40);
    locationL.frame = CGRectMake(110, 60 + 47 *cityArr.count, 160, 40);
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hidden) userInfo:nil repeats:NO];
    [timer userInfo];
    if (locFlag == NO)
    {
        return 1;
    }
    else if (searchCity.text.length < 1)
    {
        return [cityArr count] + 1;
    }
    else
    {
        return [reloadCA count] + 1;
    }
}

#pragma -mark 隐藏活动指示器
- (void)hidden
{
    locationL.hidden = YES;
    [locActivity stopAnimating];
}

#pragma -mark 开始获取我的位置
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

#pragma -mark 利用经纬度获取我的位置
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location=[locations lastObject];
    
    CLLocation *thelocation = [[CLLocation alloc]initWithLatitude:location.coordinate.latitude - 0.0030 longitude:location.coordinate.longitude + 0.0051]; //位置反编码
    [self Getlocation:thelocation];
    locationL.hidden = NO;
    [locActivity startAnimating];
    
    
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
    
    [locationManager stopUpdatingLocation];
}


#pragma -mark 成功获取我的位置
- (void)Getlocation:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];

    //位置反编码
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         for (CLPlacemark *placemake in placemarks)
         {
             NSArray *arr = [placemake.name componentsSeparatedByString:placemake.subLocality];
             if (arr.count == 1)
             {
//                 NSLog(@"a==%@",arr[0]);
                 if ([cityArr containsObject:arr[0]] == NO)
                 {
                     [cityArr addObject:arr[0]];
                     [raingeArr addObject:placemake.subLocality];
                     [locationTV reloadData];
                     locationL.hidden = NO;
                     [locActivity startAnimating];
                 }
             }
             else if(arr.count == 2)
             {
//                 NSLog(@"a==%@",arr[1]);
                 if ([cityArr containsObject:arr[1]] == NO)
                 {
                     [cityArr addObject:arr[1]];
                     [raingeArr addObject:placemake.subLocality];
                     [locationTV reloadData];
                     locationL.hidden = NO;
                     [locActivity startAnimating];
                 }
             }
//             NSLog(@"d==%@",placemake.locality);
//             NSLog(@"e==%@",placemake.subLocality);
         }
     }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if (locFlag == YES)
        {
            locFlag = NO;
            [cityArr removeAllObjects];
            [raingeArr removeAllObjects];
        }
        else
        {
            locFlag = YES;
            [self connNet];
        }
        [locationTV reloadData];
    }
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
