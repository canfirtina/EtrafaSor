//
//  MapViewController.h
//  EtrafaSor
//
//  Created by Can Firtina on 21/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define RADIUS 375

@interface MapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *peopleAroundLabel;
@property (weak, nonatomic) IBOutlet UIButton *goBackButton;
@end
