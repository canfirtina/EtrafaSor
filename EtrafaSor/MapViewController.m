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
#import "MessageBoardViewController.h"
#import "UIImageView+WebCache.h"

const float lonDegree = 0.0135; //denominator = 750m, 2*750 = 1500, 1500/111000 = 0.0135 (111000 meters is distance between two longtitudes)
const float letDegree = 0.0135; //denominator = 750m, 2*750 = 1500, 1500/111000 = 0.0135 (111000 meters is an approximate distance between two latitudes)

@interface MapViewController () <EtrafaSorHTTPRequestHandlerDelegate>
@property (strong, nonatomic) NSTimer *questionLoadTimer;
@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize peopleAroundLabel = _peopleAroundLabel;
@synthesize goBackButton = _goBackButton;
@synthesize userProfile = _userProfile;
@synthesize questionLoadTimer = _questionLoadTimer;

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    //Gesture Recognizer Creations
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(mapViewLongPressed:)];
    longPress.minimumPressDuration = 1;
    [self.mapView addGestureRecognizer:longPress];
    
    //Notification Registrations
    [self.userProfile attachObserverForCoordinateChange:self];
    
    //Timers
    
    //update location timer
    [NSTimer scheduledTimerWithTimeInterval:60.0
                                     target:self
                                   selector:@selector(updateLocation)
                                   userInfo:nil
                                    repeats:YES];
}

#pragma mark - Setters & Getters

- (Profile *)userProfile {
    
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] profile];;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    if( self.goBackButton.hidden && [userLocation.location distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.userProfile.coordinate.latitude longitude:self.userProfile.coordinate.longitude]] > 30)
        [self setRegionForCoordinate:userLocation.coordinate];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationView *pinAnnotationView = nil;
    
    if( [annotation isKindOfClass:[Profile class]]){
        
        Profile *profile = (Profile *)annotation;
        pinAnnotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Profile Annotation"];
        
        if( !pinAnnotationView){
            
            pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:@"Profile Annotation"];
            
            pinAnnotationView.pinColor = MKPinAnnotationColorRed;
            pinAnnotationView.animatesDrop = YES;
            pinAnnotationView.canShowCallout = YES;
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setImageWithURL:profile.userImageURL placeholderImage:[UIImage imageNamed:@"defaultProfilePicture"]];
            imageView.frame = CGRectMake(0,0,32,32);
            pinAnnotationView.leftCalloutAccessoryView = imageView;
            
            pinAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
        }
        
        return pinAnnotationView;
        
    } else if( [annotation isKindOfClass:[Question class]]){
        
        Question *question = (Question *)annotation;
        pinAnnotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Question Annotation"];
        
        if( !pinAnnotationView){
            
            pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:[NSString stringWithFormat:@"Question Annotation"]];
            pinAnnotationView.pinColor = MKPinAnnotationColorGreen;
            pinAnnotationView.animatesDrop = YES;
            pinAnnotationView.canShowCallout = YES;
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setImageWithURL:question.owner.userImageURL placeholderImage:[UIImage imageNamed:@"defaultProfilePicture"]];
            imageView.frame = CGRectMake(0,0,32,32);
            pinAnnotationView.leftCalloutAccessoryView = imageView;
            
            pinAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        
        return pinAnnotationView;
    }
    
    return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if( [view.annotation isKindOfClass:[Profile class]]){
        
        [self performSegueWithIdentifier:@"CreateQuestionModal" sender:self];
        
    } else if( [view.annotation isKindOfClass:[Question class]]){
        
        [self performSegueWithIdentifier:@"MessageBoardModal" sender:view.annotation];
    }
}

#pragma mark - EtrafaSorHTTPRequestManagerDelegate

- (void)connectionHasFinishedWithData:(NSDictionary *)data {
    
    NSLog(@"%@", data);
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

- (IBAction)goBackPressed:(UIButton *)sender {
    
    [self.goBackButton setHidden:YES];
    [self setRegionForCoordinate:self.mapView.userLocation.coordinate];
}

#pragma mark - Notifications

- (void)updateProfileCoordinate {
    
    if( [self.mapView.annotations containsObject:self.userProfile])
        [self.mapView removeAnnotation:self.userProfile];

    [self.mapView addAnnotation:self.userProfile];
}

#pragma mark - NSTimer Mesages

- (void)loadQuestions {
    
    [self loadQuestionsAroundCenterCoordinate:self.userProfile.coordinate];
}

- (void)updateLocation {
    
    [EtrafaSorHTTPRequestHandler updateUserCheckIn:self.userProfile inCoordinate:self.mapView.userLocation.coordinate sender:self];
}

#pragma mark - MapView Controls

- (void)setRegionForCoordinate:(CLLocationCoordinate2D)coordinate {
    
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(letDegree, lonDegree))
                   animated:YES];
    
    //Set timer for loading questions
    [self.questionLoadTimer invalidate];
    self.questionLoadTimer = nil;
    self.questionLoadTimer = [NSTimer scheduledTimerWithTimeInterval:45.0
                                                              target:self
                                                            selector:@selector(loadQuestions)
                                                            userInfo:nil
                                                             repeats:YES];
    
    [self.userProfile setCoordinate:coordinate];
    [self loadQuestionsAroundCenterCoordinate:coordinate];
    [self loadPeopleAroundCenterCoordinate:coordinate];
}

- (void)loadQuestionsAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate {
    
    NSMutableArray *questionAnnotations = [self.mapView.annotations mutableCopy];
    
    if( [questionAnnotations containsObject:self.userProfile])
        [questionAnnotations removeObject:self.userProfile];
    
    [self.mapView removeAnnotations:[questionAnnotations copy]];
    
    [self.mapView addAnnotations:[EtrafaSorHTTPRequestHandler fetchQuestionsAroundCenterCoordinate:coordinate
                                                           withRadius:RADIUS
                                                               sender:self]];
}

- (void)loadPeopleAroundCenterCoordinate:(CLLocationCoordinate2D)coordinate {
    
    [EtrafaSorHTTPRequestHandler peopleAroundCenterCoordinate:coordinate
                                                   withRadius:RADIUS
                                                       sender:self];
    
    self.peopleAroundLabel.text = [NSString stringWithFormat:@"%d people around you", 0];
}

#pragma mark - Segue

- (IBAction)dismissByCancelToMapViewController:(UIStoryboardSegue *)segue {}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    
    if( [segue.identifier isEqualToString:@"MessageBoardModal"]){
        
        Question *question = [sender isKindOfClass:[Question class]]?sender:nil;
        MessageBoardViewController *mbvc = nil;
        
        if( [segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nvc = (UINavigationController *)segue.destinationViewController;
            mbvc = (MessageBoardViewController *)nvc.topViewController;
        } else if( [segue.destinationViewController isKindOfClass:[MessageBoardViewController class]])
            mbvc = (MessageBoardViewController *)segue.destinationViewController;
        
        mbvc.question = question;
    }
}

@end
