//
//  QuestionsTableViewController.h
//  EtrafaSor
//
//  Created by Can Firtina on 22/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

#define RADIUS 375

@interface QuestionsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *questions; //array of Questions

@end
