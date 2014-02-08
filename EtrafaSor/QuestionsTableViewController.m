//
//  QuestionsTableViewController.m
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "QuestionsTableViewController.h"
#import "Message.h"
#import "Profile.h"
#import "EtrafaSorHTTPRequestHandler.h"
#import "AppDelegate.h"
#import "MessageBoardViewController.h"

@interface QuestionsTableViewController () <EtrafaSorHTTPRequestHandlerDelegate>
@property (nonatomic, readonly, copy) Profile *userProfile;
@end

@implementation QuestionsTableViewController

@synthesize questions = _questions;
@synthesize userProfile = _userProfile;

#pragma mark - System

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [NSTimer scheduledTimerWithTimeInterval:45.0 target:self selector:@selector(fetchAndSetQuestionsAsynchronously) userInfo:nil repeats:YES];
}

#pragma mark - Setters & Getters

- (NSArray *)questions {
    
    if( !_questions)
        [self fetchAndSetQuestionsAsynchronously];
    
    return _questions;
}

- (void)setQuestions:(NSArray *)questions {
    
    if( _questions.count != questions.count){
        
        _questions = questions;
        [self.tableView reloadData];
    } else {
        
        NSArray *myQuestionsCopy = [_questions copy];
        myQuestionsCopy = [myQuestionsCopy sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            return [((Question *)obj1).title caseInsensitiveCompare:((Question *)obj1).title];
        }];
        
        NSArray *questionsCopy = [questions copy];
        questionsCopy = [questionsCopy sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            return [((Question *)obj1).title caseInsensitiveCompare:((Question *)obj1).title];
        }];
        
        if( ![myQuestionsCopy isEqualToArray:questionsCopy]){
            
            _questions = questions;
            [self.tableView reloadData];
        }
    }
}

- (Profile *)userProfile {
    
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] profile];;
}

#pragma mark - Data Fetch

- (void)fetchAndSetQuestionsAsynchronously {
    
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:ai];
    [ai startAnimating];
    
    [EtrafaSorHTTPRequestHandler questionsAroundCenterCoordinate:self.userProfile.coordinate
                                                      withRadius:RADIUS
                                                            user:self.userProfile
                                                          sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Questions Around";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Questions Around"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Question *question = [self.questions objectAtIndex:indexPath.row];
    
    cell.textLabel.text = question.title;
    cell.detailTextLabel.text = question.subtitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    [self performSegueWithIdentifier:@"MessageBoardModal" sender:[self.questions objectAtIndex:indexPath.row]];
}

#pragma mark - EtrafaSorHTTPRequestHandlerDelegate Delegate & Parse

- (Question *)parseQuestionData:(NSDictionary *)questionData {
    
    NSDictionary *userInfo = [questionData objectForKey:@"user"];
    Profile *owner = [Profile profileWithUserId:[userInfo objectForKey:@"userId"]
                                      userEmail:nil
                                       userName:[userInfo objectForKey:@"userName"]
                                       imageURL:[NSURL URLWithString:@"http://canfirtina.com/projectTrials/profile.jpg"]];
    
    Question *question = [Question questionWithTopic:[questionData objectForKey:@"title"]
                                     questionMessage:[questionData objectForKey:@"text"]
                                               owner:owner];
    
    return question;
}

- (void)connectionHasFinishedWithData:(NSDictionary *)data {
    
    if( data) {
        
        for(id key in data) {
            
            id value = [data objectForKey:key];
            
            NSString *keyAsString = (NSString *)key;
            
            if( [keyAsString isEqualToString:@"content"]) {
                
                if( [value isKindOfClass:[NSArray class]]) {
                    
                    NSMutableArray *questionsForTableView = [NSMutableArray array];
                    NSArray *questions = value;
                    
                    for( NSDictionary *questionData in questions)
                        [questionsForTableView addObject:[self parseQuestionData:questionData]];
                    
                    self.questions = [questionsForTableView copy];
                    self.navigationItem.rightBarButtonItem = nil;
                }
            }
        }
    }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
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