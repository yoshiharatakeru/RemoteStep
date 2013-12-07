//
//  MapViewController.m
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/12/07.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
{
    //outlet
    __weak IBOutlet UISlider *_slider;
    __weak IBOutlet MKMapView *_mapView1;
    __weak IBOutlet MKMapView *_mapView2;
    
}

@end

@implementation MapViewController

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
    
    //slider
    _slider.minimumValue = 0;
    _slider.maximumValue = 1;
    _slider.value = 0.5f;
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //mapView
    _mapView2.alpha = _slider.value;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark private method

- (void)sliderValueChanged:(UISlider*)slider
{
    _mapView2.alpha = slider.value;

    
}

@end
