//
//  TXBMapViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/11/28.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXBMapViewController.h"
#import "TXTransformLocationTool.h"

@interface TXBMapViewController () <MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation TXBMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [NSString stringWithFormat:@"%@", self.storeDetailModel.name];

    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopHeight)];
    self.mapView.delegate = self;
    _mapView.mapType = MAMapTypeStandard;
    _mapView.zoomEnabled = true;
    _mapView.scrollEnabled = true;
//    _mapView.zoomLevel = 15;
    _mapView.showsScale = true;
    //开启定位
    _mapView.showsUserLocation = true;
    [self.view addSubview:self.mapView];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = [self.storeDetailModel.latitude doubleValue];
    coor.longitude = [self.storeDetailModel.longitude doubleValue];
    pointAnnotation.coordinate = coor;
    pointAnnotation.title = self.storeDetailModel.name;
    pointAnnotation.subtitle = self.storeDetailModel.address;
    _mapView.centerCoordinate = coor;
    [_mapView addAnnotation:pointAnnotation];
}

- (void)viewWillDisappear:(BOOL)animated {
    _mapView.showsUserLocation = NO;
    _mapView.delegate = nil;
    [super viewWillDisappear:animated];
}

- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    //大头针标注
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {//判断是否是自己的定位气泡，如果是自己的定位气泡，不做任何设置，显示为蓝点，如果不是自己的定位气泡，比如大头针就会进入
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAAnnotationView*annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.frame = CGRectMake(0, 0, 100, 100);
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        //annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;           //设置标注可以拖动，默认为NO
        //        annotationView.pinColor = MAPinAnnotationColorPurple;
        
        //设置大头针显示的图片
        annotationView.image = [UIImage imageNamed:@"ic_main_location"];
        //点击大头针显示的左边的视图
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backImage"]];
        annotationView.leftCalloutAccessoryView = imageV;
        //点击大头针显示的右边视图
//        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
//        rightButton.backgroundColor = [UIColor grayColor];
//        [rightButton setTitle:@"导航" forState:UIControlStateNormal];
//        annotationView.rightCalloutAccessoryView = rightButton;
        
        //        annotationView.image = [UIImage imageNamed:@"redPin"];
        return annotationView;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
