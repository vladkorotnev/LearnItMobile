//
//  LISprintViewController.h
//  LearnItMobile
//
//  Created by Vladislav Korotnev on 4/7/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNumberpadDoneHelper.h"
@interface LISprintViewController : UIViewController<UIAlertViewDelegate>{
    DZNumberpadDoneHelper*numberpadDonehelper;
}
@property (retain, nonatomic) IBOutlet UILabel *answerViewer;
@property (retain, nonatomic) IBOutlet UILabel *questionViewer;
@property (retain, nonatomic) IBOutlet UIView *presetView;
@property (retain, nonatomic) IBOutlet UIProgressView *progress;
- (LISprintViewController*)initWithQuestionnaire:(NSMutableDictionary*)q;
- (IBAction)sayNo:(id)sender;
- (IBAction)plsStop:(id)sender;
- (IBAction)sayYes:(id)sender;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *stop;
@property (retain, nonatomic) IBOutlet UITextField *timeEdit;
@property (nonatomic,retain)  DZNumberpadDoneHelper*numberpadDonehelper;
@end
