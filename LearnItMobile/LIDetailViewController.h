//
//  LIDetailViewController.h
//  LearnItMobile
//
//  Created by Vladislav Korotnev on 4/7/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIQuizViewController.h"
#import "LISprintViewController.h"
@interface LIDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) id detailItem;

@property (retain, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
- (IBAction)insertQuestion:(id)sender;
- (IBAction)testPerform:(id)sender;

@end
