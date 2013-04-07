//
//  LIMasterViewController.h
//  LearnItMobile
//
//  Created by Vladislav Korotnev on 4/7/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYIntroductionView.h"
@class LIDetailViewController;

@interface LIMasterViewController : UITableViewController<MYIntroductionDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) LIDetailViewController *detailViewController;

@end
