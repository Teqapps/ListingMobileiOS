//
//  AddFavTableViewController.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 1/8/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

#import "AddFavTableViewController.h"
#import "FavDataManager.h"

#import "SWRevealViewController.h"
#import "Tattoo_Detail_ViewController.h"
#import "TattooMaster_ViewController.h"
#import "MainViewController.h"
#import "DetailFavViewController.h"
@import CoreData;
@interface AddFavTableViewController ()
@property (strong, nonatomic) NSArray *dataSource;
@end

@implementation AddFavTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchFavourites];
     NSLog(@"%@",[self.dataSource valueForKey:@"name"]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    // Refetch results only when there is an update to coredata
    if ([[FavDataManager sharedInstance] hasUpdated]){
        [self fetchFavourites];
    }
    
    // if no data available to show, ask if go back to search
    if ([self.dataSource count] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"沒有我的最愛"
                                                            message:@"需要尋找師傅？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"確定", nil];
        alertView.delegate = self;
        [alertView show];
        
    }
    
}
- (void)fetchFavourites{
    FavDataManager *manager = [FavDataManager sharedInstance];
    NSManagedObjectContext *context = [manager mainObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Venue" inManagedObjectContext:context];
    
    [request setEntity:entityDescription];
    [request setPredicate:nil];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    self.dataSource = results;
    
 NSLog(@"%d results fetched.", results.count);
    [self.tableView reloadData];
    
}
#pragma mark - alertView delegate action
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
    if([button isEqualToString:@"確定"])
    {
        
          [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TattooMaster_ViewController"] animated:YES];
        
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoritedVenueCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.dataSource[indexPath.row] valueForKey:@"name"];
    
   cell.detailTextLabel.text = [self.dataSource[indexPath.row] valueForKey:@"address"];
    cell.detailTextLabel.textColor =[UIColor blueColor];
    NSString *picURLstring = [NSString stringWithFormat:@"https://localhost:443/phpMyAdmin/fyp_php/master_0%@.jpg",[self.dataSource[indexPath.row] valueForKey:@"master_id"] ] ;
    NSURL *picURL = [NSURL URLWithString:picURLstring] ;
    
    UIImage *Slide = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:picURL]];
    
    cell.imageView.image = Slide;
      //  cell.imageView.image = [UIImage imageNamed:[self.dataSource[indexPath.row] valueForKey:@"image"]  ];
    
    CGSize itemSize = CGSizeMake(70, 70);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    //set 師傅 icon 有個框框，圓角
    cell.imageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    cell.imageView.layer.cornerRadius=20;
    cell.imageView.layer.borderWidth=2.0;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.borderColor=[[UIColor redColor] CGColor];
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    

    return cell;
}


#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"PushFavDetailSegue"]) {
  

        if ([segue.destinationViewController isKindOfClass:[DetailFavViewController class]]){
            NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
            DetailFavViewController *receiver = (DetailFavViewController*)segue.destinationViewController;
            receiver.data = self.dataSource[indexPath.row];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
}


    


#pragma mark - Segue


@end
