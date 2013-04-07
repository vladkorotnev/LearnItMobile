//
//  LISprintViewController.m
//  LearnItMobile
//
//  Created by Vladislav Korotnev on 4/7/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "LISprintViewController.h"

@interface LISprintViewController ()
{
    NSMutableDictionary*questions;
}
@end

@implementation LISprintViewController
static float remain=60;
static float totalTime=60;
static int answ=0;
static int corransw=0;
static bool isTicking=false;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (LISprintViewController*)initWithQuestionnaire:(NSMutableDictionary*)q {
   [self init];
    questions= [q copy];
    return self;
}
- (void)doneAction:(id)sender{
    [[NSUserDefaults standardUserDefaults]setInteger:self.timeEdit.text.integerValue forKey:@"sprintTime"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    totalTime=self.timeEdit.text.floatValue;
    remain=totalTime;
    answ=0;
    corransw=0;
    isTicking=false;
    [self.timeEdit resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        [self.presetView setAlpha:0];
    } completion:^(BOOL finished) {
        if(finished)
            [self.presetView removeFromSuperview];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pw_maze_white"]]];
    [self.presetView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pw_maze_white"]]];
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"sprintTime"] <= 0) {
         [[NSUserDefaults standardUserDefaults]setInteger:60 forKey:@"sprintTime"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"Defaulted");
    }
    [self _seed];
    
    [self.presetView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.presetView];
    [self.timeEdit setText:[NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults]integerForKey:@"sprintTime"]]];
    [self.numberpadDonehelper registerObservers];
}
-(void)viewDidAppear:(BOOL)animated {
    [self.timeEdit becomeFirstResponder];
}
- (void)viewDidDisappear:(BOOL)animated{
    [self.numberpadDonehelper unRegisterObservers];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
      self.numberpadDonehelper = [[[DZNumberpadDoneHelper alloc] initWithTarget:self doneAction:@selector(doneAction:)] autorelease];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_presetView release];
    [_timeEdit release];
    [_questionViewer release];
    [_answerViewer release];
    [_progress release];
    [_stop release];
    [super dealloc];
}
- (void)viewDidUnload {
    self.numberpadDonehelper = nil;
    [self setPresetView:nil];
    [self setTimeEdit:nil];
    [self setQuestionViewer:nil];
    [self setAnswerViewer:nil];
    [self setProgress:nil];
    [self setStop:nil];
    [super viewDidUnload];
}
-(void)_tick {
    isTicking=true;
    if (remain == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Completed!" message:[NSString stringWithFormat:@"%i out of %i were answered correctly",corransw,answ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        [self.progress setProgress:0 animated:true];
        isTicking=false;
    } else {
        remain--;
        //NSLog(@"Tick: %f %f",remain,(remain/totalTime));
        [self.progress setProgress:(remain/totalTime) animated:true];
        [self performSelector:@selector(_tick) withObject:nil afterDelay:1];
    }
}
-(void)_seed{
    self.questionViewer.text = questions.allKeys[arc4random()%(questions.allKeys.count-1)];
    self.answerViewer.text = [questions objectForKey:questions.allKeys[arc4random()%(questions.allKeys.count-1)]];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissModalViewControllerAnimated:true];
}
- (IBAction)sayNo:(id)sender {
    if(!isTicking)
        [self _tick];
    answ++;
    if (![[questions objectForKey:self.questionViewer.text]isEqualToString:self.answerViewer.text]) {
        corransw++;
    }
    [self _seed];
}

- (IBAction)plsStop:(id)sender {
    remain=0;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_tick) object:nil];
    [self dismissModalViewControllerAnimated:true];
}

- (IBAction)sayYes:(id)sender {
    if(!isTicking)
        [self _tick];
    answ++;
    if ([[questions objectForKey:self.questionViewer.text]isEqualToString:self.answerViewer.text]) {
        corransw++;
    }
    [self _seed];
}
@end
