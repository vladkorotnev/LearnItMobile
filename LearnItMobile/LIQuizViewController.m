//
//  LIQuizViewController.m
//  LearnItMobile
//
//  Created by Vladislav Korotnev on 4/7/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//



#import "LIQuizViewController.h"

@interface LIQuizViewController ()
{
    NSMutableArray*alreadyPresentedQuestions;
    NSDictionary*questionnaire;
}
@end

@implementation LIQuizViewController
static int totalAnswered=0;
static int correctAnswers=0;
const char* easterEgg="This module heavily copied from Neene Arora's KanaTest which was made by me and not paid for :P In the meantime, stop viewing the binary in the text editor";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)stopit:(id)sender {
    [self dismissModalViewControllerAnimated:true];
}

- (LIQuizViewController*)initWithQuestionnaire:(NSMutableDictionary*)q {
    [self init];
    questionnaire= [q copy];
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [self _seed];
    totalAnswered=0;
    correctAnswers=0;
     self.progress.progress = (float)totalAnswered/(float)questionnaire.allKeys.count;
    alreadyPresentedQuestions = [NSMutableArray new];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"escheresque_ste"]]];
}
- (void)viewDidAppear:(BOOL)animated{
}
-(void)_seed {
    totalAnswered = totalAnswered+1;
    if (alreadyPresentedQuestions.count == questionnaire.allKeys.count) {
        // Done all questions correctly yay
        [[[UIAlertView alloc]initWithTitle:@"Well done!" message:@"You've done it right! Congratulations!" delegate:self cancelButtonTitle:@"Yay!" otherButtonTitles:nil]show];
        [self dismissModalViewControllerAnimated:true];
               return;
        
    }
    self.progress.progress = (float)totalAnswered/(float)questionnaire.allKeys.count;
    int newNumber = arc4random() % questionnaire.allKeys.count;
    if((alreadyPresentedQuestions.count + 1) == questionnaire.allKeys.count){
        // prevent lockup when 1 question left
        for (NSString*shit in questionnaire.allKeys) {
            if (![alreadyPresentedQuestions containsObject:shit]) {
                newNumber = [questionnaire.allKeys indexOfObject:shit];
            }
        }
    }   else
        while ([alreadyPresentedQuestions containsObject:[questionnaire.allKeys objectAtIndex:newNumber]]) {
            newNumber = arc4random() % questionnaire.allKeys.count;
        }
    
    [alreadyPresentedQuestions addObject:[questionnaire.allKeys objectAtIndex:newNumber]];
    // save so the question wont repeat
    
    
    self.currentSym.text = [questionnaire objectForKey:[questionnaire.allKeys objectAtIndex:newNumber]];
    
    int curCorrectOne = (arc4random() % 4)+1;
    
    switch (curCorrectOne) {
        case 1:
            [self.button1 setTitle:[questionnaire.allKeys objectAtIndex:newNumber] forState:UIControlStateNormal];
            int shit = newNumber;
            while (shit == newNumber) {
                shit = arc4random()  % questionnaire.allKeys.count ;
            }
            [self.button2 setTitle:[questionnaire.allKeys objectAtIndex:shit] forState:UIControlStateNormal];
            int shit2 = newNumber;
            while (shit2 == newNumber || shit2 == shit) {
                shit2 = arc4random()  % questionnaire.allKeys.count ;
            }
            [self.button3 setTitle:[questionnaire.allKeys objectAtIndex:shit2] forState:UIControlStateNormal];
            int shit3 = newNumber;
            while (shit3 == newNumber || shit3 == shit || shit3 == shit2) {
                shit3 = arc4random()  % questionnaire.allKeys.count ;
            }
            [self.button4 setTitle:[questionnaire.allKeys objectAtIndex:shit3] forState:UIControlStateNormal];
            break;
            
        case 2:
            [self.button2 setTitle:[questionnaire.allKeys objectAtIndex:newNumber] forState:UIControlStateNormal];
            int ashit = newNumber;
            while (ashit == newNumber) {
                ashit = arc4random()  % questionnaire.allKeys.count ;
            }
            [self.button1 setTitle:[questionnaire.allKeys objectAtIndex:ashit] forState:UIControlStateNormal];
            int ashit2 = newNumber;
            while (ashit2 == newNumber || ashit2 == ashit) {
                ashit2 = arc4random()  % questionnaire.allKeys.count ;
            }
            [self.button3 setTitle:[questionnaire.allKeys objectAtIndex:ashit2] forState:UIControlStateNormal];
            int ashit3 = newNumber;
            while (ashit3 == newNumber || ashit3 == ashit || ashit3 == ashit2) {
                ashit3 = arc4random()  % questionnaire.allKeys.count ;
            }
            [self.button4 setTitle:[questionnaire.allKeys objectAtIndex:ashit3] forState:UIControlStateNormal];
            break;
        case 3:
            [self.button3 setTitle:[questionnaire.allKeys objectAtIndex:newNumber] forState:UIControlStateNormal];
            int bshit = newNumber;
            while (bshit == newNumber) {
                bshit = arc4random()  % questionnaire.allKeys.count ;
            }
            [self.button2 setTitle:[questionnaire.allKeys objectAtIndex:bshit] forState:UIControlStateNormal];
            int bshit2 = newNumber;
            while (bshit2 == newNumber || bshit2 == bshit) {
                bshit2 = arc4random()  % questionnaire.allKeys.count ;
            }
            [self.button1 setTitle:[questionnaire.allKeys objectAtIndex:bshit2] forState:UIControlStateNormal];
            int bshit3 = newNumber;
            while (bshit3 == newNumber || bshit3 == bshit || bshit3 == bshit2) {
                bshit3 = arc4random()  % questionnaire.allKeys.count ;
            }
            [self.button4 setTitle:[questionnaire.allKeys objectAtIndex:bshit3] forState:UIControlStateNormal];
            break;
        case 4:
            [self.button4 setTitle:[questionnaire.allKeys objectAtIndex:newNumber] forState:UIControlStateNormal];
            int cshit = newNumber;
            while (cshit == newNumber) {
                cshit = arc4random()  % questionnaire.allKeys.count ;
            }
            [self.button2 setTitle:[questionnaire.allKeys objectAtIndex:cshit] forState:UIControlStateNormal];
            int cshit2 = newNumber;
            while (cshit2 == newNumber || cshit2 == cshit) {
                cshit2 = arc4random()  % questionnaire.allKeys.count ;
            }
            [self.button3 setTitle:[questionnaire.allKeys objectAtIndex:cshit2] forState:UIControlStateNormal];
            int cshit3 = newNumber;
            while (cshit3 == newNumber || cshit3 == cshit || cshit3 == cshit2) {
                cshit3 = arc4random()  % questionnaire.allKeys.count ;
            }
            [self.button1 setTitle:[questionnaire.allKeys objectAtIndex:cshit3] forState:UIControlStateNormal];
            break;
            
        default:
            NSLog(@"WTF, shit!");
            break;
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"Hint"]) {
        if ([[questionnaire objectForKey:self.button1.titleLabel.text] isEqualToString:self.currentSym.text]) {
            [self.button1 setBackgroundColor:[UIColor redColor]];
            [self.button1 performSelector:@selector(setBackgroundColor:) withObject:[UIColor clearColor] afterDelay:0.5];
            return;
        }
        if ([[questionnaire objectForKey:self.button2.titleLabel.text] isEqualToString:self.currentSym.text]) {
            [self.button2 setBackgroundColor:[UIColor redColor]];
            [self.button2 performSelector:@selector(setBackgroundColor:) withObject:[UIColor clearColor] afterDelay:0.5];
            return;
        }
        if ([[questionnaire objectForKey:self.button3.titleLabel.text] isEqualToString:self.currentSym.text]) {
            [self.button3 setBackgroundColor:[UIColor redColor]];
            [self.button3 performSelector:@selector(setBackgroundColor:) withObject:[UIColor clearColor] afterDelay:0.5];
            return;
        }
        if ([[questionnaire objectForKey:self.button4.titleLabel.text] isEqualToString:self.currentSym.text]) {
            [self.button4 setBackgroundColor:[UIColor redColor]];
            [self.button4 performSelector:@selector(setBackgroundColor:) withObject:[UIColor clearColor] afterDelay:0.5];
            return;
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    [_button1 release];
    [_button2 release];
    [_button3 release];
    [_button4 release];
    [_currentSym release];
    [_progress release];
    [super dealloc];
}
- (void)viewDidUnload {

    [self setButton1:nil];
    [self setButton2:nil];
    [self setButton3:nil];
    [self setButton4:nil];
    [self setCurrentSym:nil];
    [self setProgress:nil];
    [super viewDidUnload];
}
- (IBAction)sayAns:(UIButton *)sender {
    if ([[questionnaire objectForKey:sender.titleLabel.text] isEqualToString:self.currentSym.text]) {
        
        correctAnswers++;
        [self _seed];
    } else {
       [[[UIAlertView alloc]initWithTitle:@"Incorrect" message:@"Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Hint", nil]show ];
    }
}
@end
