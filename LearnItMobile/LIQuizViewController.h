//
//  LIQuizViewController.h
//  LearnItMobile
//
//  Created by Vladislav Korotnev on 4/7/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIQuizViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *button1;
@property (retain, nonatomic) IBOutlet UIButton *button2;
@property (retain, nonatomic) IBOutlet UIButton *button3;
@property (retain, nonatomic) IBOutlet UIButton *button4;
@property (retain, nonatomic) IBOutlet UILabel *currentSym;

@property (retain, nonatomic) IBOutlet UIProgressView *progress;

- (IBAction)sayAns:(UIButton *)sender;

- (IBAction)stopit:(id)sender;
- (LIQuizViewController*)initWithQuestionnaire:(NSMutableDictionary*)q;
@end
