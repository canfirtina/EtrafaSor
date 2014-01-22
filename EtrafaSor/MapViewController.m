//
//  MapViewController.m
//  EtrafaSor
//
//  Created by Can Firtina on 21/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "MapViewController.h"
#import "EtrafaSorHTTPRequestHandler.h"
#import "AppDelegate.h"

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
    
    self.userProfile = [(AppDelegate *)[[UIApplication sharedApplication] delegate] profile];
    self.mapView.delegate = self;
    
    //Gesture Recognizer Creations
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(mapViewLongPressed:)];
    longPress.minimumPressDuration = 1;
    [self.mapView addGestureRecognizer:longPress];
    
    //Notification Registrations
    [self.userProfile attachObserverForCoordinateChange:self];
}

#pragma mark - Setters & Getters

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if( self.goBackButton.hidden){
        
        [self setRegionForCoordinate:userLocation.coordinate];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKAnnotationView *annotationView = nil;
    
    if( [annotation isKindOfClass:[Profile class]]){
        
        Profile *profile = (Profile *)annotation;
        
        MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:profile.userEMail];
        
        if( !annotationView){
            
            pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:profile.userEMail];
            pinAnnotationView.pinColor = MKPinAnnotationColorRed;
            pinAnnotationView.animatesDrop = YES;
            pinAnnotationView.canShowCallout = YES;
            
            pinAnnotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[[UIImage imageWithData:[NSData dataWithContentsOfURL:profile.userImageURL]] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
        }
        
        return pinAnnotationView;
        
    } else if( [annotation isKindOfClass:[Question class]]){
        
        
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    
    NSLog(@"tapped");
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
}

#pragma mark - Notifications

- (void)updateProfileCoordinate {
    
    if( [self.mapView.annotations containsObject:self.userProfile])
        [self.mapView removeAnnotation:self.userProfile];
    
    [self.mapView addAnnotation:self.userProfile];
}
#pragma mark - MapView Controls

- (void)setRegionForCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(letDegree, lonDegree))
                   animated:YES];
    
    [self.userProfile setCoordinate:coordinate];
    [self loadQuestionsAroundCenterCoordinate:coordinate];
    [self loadPeopleAroundCenterCoordinate:coordinate];
}

- (void)loadQuestionsAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:[EtrafaSorHTTPRequestHandler fetchQuestionsAroundCenterCoordinate:coordinate withRadius:RADIUS]];
}

- (void)loadPeopleAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSArray *peopleAround = [EtrafaSorHTTPRequestHandler fetchPeopleAroundCenterCoordinate:coordinate withRadius:RADIUS];
    
    self.peopleAroundLabel.text = [NSString stringWithFormat:@"%d people around you", (int)peopleAround.count];
}
@end
