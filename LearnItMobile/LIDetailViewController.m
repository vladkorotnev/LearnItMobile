//
//  LIDetailViewController.m
//  LearnItMobile
//
//  Created by Vladislav Korotnev on 4/7/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "LIDetailViewController.h"

@interface LIDetailViewController (){
    NSMutableDictionary*questions;
}
- (void)configureView;
@end

@implementation LIDetailViewController

- (void)dealloc
{
    [_detailItem release];
    [_detailDescriptionLabel release];
    [_table release];
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];

        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.title = [[self.detailItem lastPathComponent]stringByReplacingOccurrencesOfString:@".lit" withString:@""];
        questions = [[NSDictionary dictionaryWithContentsOfFile:self.detailItem]mutableCopy];
        [questions retain];
    }
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editing:)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;
  
   
}

-(void)editing:(UIBarButtonItem*)sender{
    if ([sender.title isEqualToString:@"Edit"]) {
        [sender setStyle:UIBarButtonItemStyleDone];
        [self.table setEditing:true animated:true];
        [sender setTitle:@"Done"];
    } else {
        [self.table setEditing:false animated:true];
        [sender setStyle:UIBarButtonItemStyleBordered];
        [sender setTitle:@"Edit"];
    }
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return questions.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    
    NSString *object = questions.allKeys[indexPath.row];
    cell.textLabel.text = object;
    cell.detailTextLabel.text = [questions objectForKey:questions.allKeys[indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [questions removeObjectForKey:[[questions allKeys]objectAtIndex:indexPath.row]];
        [questions writeToFile:self.detailItem atomically:false];
    }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView*a = [[UIAlertView alloc]initWithTitle:@"Edit answer" message:questions.allKeys[indexPath.row] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    [a setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [a textFieldAtIndex:0].text = [tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text;
    [a show];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
- (void)viewDidUnload {
    [self setTable:nil];
    [super viewDidUnload];
}
- (IBAction)insertQuestion:(id)sender {
    UIAlertView*a = [[UIAlertView alloc]initWithTitle:@"Create new question" message:@"Enter the question:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [a setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [a show];
}

- (IBAction)testPerform:(id)sender {
    if ([questions count]<4) {
        [[[UIAlertView alloc]initWithTitle:@"Oops!" message:@"You need at least 4 questions to run tests!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil]show];
        return;
    }
    [[[UIActionSheet alloc]initWithTitle:@"Select a test" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Sprint",@"Quiz",@"Reverse Quiz", nil]showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%@",[actionSheet buttonTitleAtIndex:buttonIndex]);
    if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Sprint"]) {
        LISprintViewController*sp = [[LISprintViewController alloc]initWithQuestionnaire:questions];
        [sp setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentModalViewController:sp animated:true];
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Quiz"]) {
        // seems like i messed them up
        NSMutableDictionary*reverseQuestions = [NSMutableDictionary new];
        for (NSString*q in questions) {
            [reverseQuestions setObject:q forKey:[questions objectForKey:q]];
        }
        LIQuizViewController*sp = [[LIQuizViewController alloc]initWithQuestionnaire:reverseQuestions];
        [sp setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentModalViewController:sp animated:true];
        
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Reverse Quiz"]) {
        LIQuizViewController*sp = [[LIQuizViewController alloc]initWithQuestionnaire:questions];
        [sp setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentModalViewController:sp animated:true];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Create new question"]) {
        if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"Add"]) {
            [questions setObject:@"Answer not set" forKey:[alertView textFieldAtIndex:0].text];
            [questions writeToFile:self.detailItem atomically:false];
            
            UIAlertView*a = [[UIAlertView alloc]initWithTitle:@"Edit answer" message:[alertView textFieldAtIndex:0].text delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
            [a setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [a show];

        }
      
        [self.table reloadData];
    }
    if ([alertView.title isEqualToString:@"Edit answer"]) {
        if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"Save"]) {
            [questions setObject:[alertView textFieldAtIndex:0].text forKey:alertView.message];
            [questions writeToFile:self.detailItem atomically:false];
        }
        
        [self.table reloadData];
    }
}
@end
