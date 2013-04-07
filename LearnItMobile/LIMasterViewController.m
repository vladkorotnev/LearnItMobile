//
//  LIMasterViewController.m
//  LearnItMobile
//
//  Created by Vladislav Korotnev on 4/7/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//
#define DOCS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#import "LIMasterViewController.h"
#import "MYIntroductionView.h"
#import "LIDetailViewController.h"

@interface LIMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation LIMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"LearnIt";
    }
    return self;
}
							
- (void)dealloc
{
    [_detailViewController release];
    [_objects release];
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated {
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"didFinishIntro"] == false) {
        //STEP 1 Construct Panels
        MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"Intro-Icon"] description:@"Welcome to LearnIt, the way to learn anything with ease!"];
        
        //You may also add in a title for each panel
        MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"book-glyph"] title:@"Get stuff done" description:@"This app will eliminate all your problems with learning languages and everything else, with ease."];
        
        
        
        /*A more customized version*/
        MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) panels:@[panel, panel2] ];
        //    [introductionView setBackgroundImage:[UIImage imageNamed:@"SampleBackground"]];
        
        
        //Set delegate to self for callbacks (optional)
        introductionView.delegate = self;
        
        //STEP 3: Show introduction view
        [introductionView showInView:self.view];
    } else {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)] autorelease];
        self.navigationItem.rightBarButtonItem = addButton;
    }
}

-(void)introductionDidFinishWithType:(MYFinishType)finishType{
    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"didFinishIntro"];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;
}

-(void)introductionDidChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _objects = [NSMutableArray new];
    for (NSString*file in [[NSFileManager defaultManager]contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] error:nil]) {
        if ([file hasSuffix:@".lit"]) {
            [_objects addObject:[file stringByReplacingOccurrencesOfString:@".lit" withString:@""]];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    [_objects removeAllObjects];
    for (NSString*file in [[NSFileManager defaultManager]contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] error:nil]) {
        if ([file hasSuffix:@".lit"]) {
            [_objects addObject:[file stringByReplacingOccurrencesOfString:@".lit" withString:@""]];
        }
    }
    UIAlertView*a = [[UIAlertView alloc]initWithTitle:@"Create new database" message:@"How shall we name it?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
    [a setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [a show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Create new database"]) {
        if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"Create"]) {
            NSDictionary*dic = @{@"Sample question": @"Sample answer",@"Another question":@"Another answer"};
            [dic writeToFile:[[DOCS stringByAppendingPathComponent:[alertView textFieldAtIndex:0].text]stringByAppendingPathExtension:@"lit"] atomically:false];
        }
        [_objects removeAllObjects];
        for (NSString*file in [[NSFileManager defaultManager]contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] error:nil]) {
            if ([file hasSuffix:@".lit"]) {
                [_objects addObject:[file stringByReplacingOccurrencesOfString:@".lit" withString:@""]];
            }
        }
      
        [self.tableView reloadData];
    }
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }


    NSString *object = _objects[indexPath.row];
    cell.textLabel.text = object ;
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
        [[NSFileManager defaultManager]removeItemAtPath:[[DOCS stringByAppendingPathComponent:[tableView cellForRowAtIndexPath:indexPath].textLabel.text]stringByAppendingPathExtension:@"lit"] error:nil];
        [_objects removeAllObjects];
        for (NSString*file in [[NSFileManager defaultManager]contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] error:nil]) {
            if ([file hasSuffix:@".lit"]) {
                [_objects addObject:[file stringByReplacingOccurrencesOfString:@".lit" withString:@""]];
            }
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
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
  
    LIDetailViewController* detailViewController = [[[LIDetailViewController alloc] initWithNibName:@"LIDetailViewController" bundle:nil] autorelease];
    
    NSString *object = _objects[indexPath.row];
    detailViewController.detailItem = [[DOCS stringByAppendingPathComponent:object]stringByAppendingPathExtension:@"lit"];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
