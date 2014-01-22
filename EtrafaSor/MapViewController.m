//
//  MapViewController.m
//  EtrafaSor
//
//  Created by Can Firtina on 21/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "MapViewController.h"

const float lonDegree = 0.0135; //denominator = 750m, 2*750 = 1500, 1500/111000 = 0.0135 (111000 meters is distance between two longtitudes)
const float letDegree = 0.0135; //denominator = 750m, 2*750 = 1500, 1500/111000 = 0.0135 (111000 meters is an approximate distance between two latitudes)

@interface MapViewController ()
@property (nonatomic, strong) MKAnnotationView *customUserLocation;
@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize peopleAroundLabel = _peopleAroundLabel;
@synthesize goBackButton = _goBackButton;
@synthesize customUserLocation = _customUserLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(mapViewLongPressed:)];
    longPress.minimumPressDuration = 1;
    [self.mapView addGestureRecognizer:longPress];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters & Getters

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if( !self.customUserLocation)
        [self setRegionForCoordinate:userLocation.coordinate];
}

#pragma mark - Gesture Recognizers
- (void)mapViewLongPressed:(UILongPressGestureRecognizer *)gesture {
    if( gesture.state == UIGestureRecognizerStateBegan){
        
        self.goBackButton.hidden = NO;
        
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[gesture locationInView:self.mapView]
                                                  toCoordinateFromView:self.mapView];
        
        [self setRegionForCoordinate:coordinate];
    }
}

#pragma mark - Actions

- (IBAction)goBackPressed:(UIButton *)sender
{
    [self setRegionForCoordinate:self.mapView.userLocation.coordinate];
    [self.goBackButton setHidden:YES];
    self.customUserLocation = nil;
}

#pragma mark - MapView Controls

- (void)setRegionForCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(letDegree, lonDegree))
                   animated:YES];
    
    [self loadQuestionsAroundCenterCoordinate:coordinate];
    [self loadPeopleAroundCenterCoordinate:coordinate];
}

- (void)loadQuestionsAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:[self questionsAroundCenterCoordinate:coordinate withRadius:RADIUS]];
}

- (void)loadPeopleAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSArray *peopleAround = [self peopleAroundCenterCoordinate:coordinate withRadius:RADIUS];
    
    self.peopleAroundLabel.text = [NSString stringWithFormat:@"%d people around you", (int)peopleAround.count];
}

#pragma mark - HTTP Requests

- (NSArray *)questionsAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                                    withRadius:(CGFloat)radius {
    
    NSMutableArray *questionAnnotations = [NSMutableArray array];
    
    //fetch questions
    
    return [questionAnnotations copy];
}

- (NSArray *)peopleAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
                               withRadius:(CGFloat)radius {
    
    NSMutableArray *peopleAround = [NSMutableArray array];
    
    //fetch people
    
    return [peopleAround copy];
}
@end
