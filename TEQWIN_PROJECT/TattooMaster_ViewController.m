//
//  TattooMaster_ViewController.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 28/7/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//
#import "HomeModel.h"
#import "Tattoo_Master_Info.h"
#import "TattooMaster_ViewController.h"
#import "Master_Map_ViewController.h"
#import "Tattoo_Detail_ViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface TattooMaster_ViewController ()
{
    int lastClickedRow;
}


@end

@implementation TattooMaster_ViewController
#define TABLE_HEIGHT 80
- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Tattoo_Master";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        //self.objectsPerPage = 10;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    like_status =@"like";
       self.navigationController.navigationBar.translucent=NO;
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"refreshTable"
                                               object:nil];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}



- (void)refreshTable:(NSNotification *) notification
{
    // Reload the recipes
    [self loadObjects];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}






- (PFQuery *)queryForTable{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    /*    if ([self.objects count] == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }*/
    
    //    [query orderByAscending:@"name"];
    
    return query;
}






- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    lastClickedRow = indexPath.row;
    
    selectobject = [self.objects  objectAtIndex:indexPath.row];
    NSLog(@"%@",[selectobject objectForKey:@"Master_id"]);
   
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"RecipeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell
    // Configure the cell
    
    
    PFFile *thumbnail = [object objectForKey:@"image"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
    CGSize itemSize = CGSizeMake(70, 70);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    thumbnailImageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    thumbnailImageView.layer.cornerRadius=8.0f;
    thumbnailImageView.layer.borderWidth=2.0;
    thumbnailImageView.layer.masksToBounds = YES;
    thumbnailImageView.layer.borderColor=[[UIColor whiteColor] CGColor];
    [thumbnailImageView.image drawInRect:imageRect];
    thumbnailImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    thumbnailImageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    
    thumbnailImageView.file = thumbnail;
    [thumbnailImageView loadInBackground];
    
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = [object objectForKey:@"Name"];
    
    UILabel *prepTimeLabel = (UILabel*) [cell viewWithTag:102];
    prepTimeLabel.text = [object objectForKey:@"Gender"];
    
    count=[object objectForKey:@"favorites"];
    
   
    UILabel *count_like = (UILabel*) [cell viewWithTag:105];
    count_like.text = [NSString stringWithFormat:@"%@%d",like_status,count.count];
    [self refreshTable:nil];
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self refreshTable:nil];
    }];
}



- (IBAction)Fav:(id)sender {
 NSIndexPath *indexPath = [self.table_view indexPathForSelectedRow];
     PFObject *object = [self.objects objectAtIndex:indexPath.row];
    NSLog(@"%@",[object objectForKey:@"Master_id"]);

    
}
- (void) likeImage {
    [object_id addUniqueObject:[PFUser currentUser].objectId forKey:@"favorites"];
    
    [object_id saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            [self likedSuccess];
            
        }
        else {
            [self likedFail];
        }
    }];
}
- (void) dislike {
    [object_id removeObject:[PFUser currentUser].objectId forKey:@"favorites"];
   
    [object_id saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            [self dislikedSuccess];
            
        }
        else {
            [self dislikedFail];
        }
    }];
}

- (void) likedSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功!" message:@"你已經加入了我的最愛" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
}

- (void) likedFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失敗!" message:@"There was an error when liking the image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
- (void) dislikedSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功!" message:@"你已經取消了我的最愛" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
}

- (void) dislikedFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失敗!" message:@"There was an error when liking the image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.table_view indexPathForSelectedRow];
        Tattoo_Detail_ViewController *destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        TattooMasterCell *tattoomasterCell = [[TattooMasterCell alloc] init];
        tattoomasterCell.object_id = [object objectForKey:@"object"];
         tattoomasterCell.favorites = [object objectForKey:@"favorites"];
        tattoomasterCell.name = [object objectForKey:@"Name"];
        tattoomasterCell.imageFile = [object objectForKey:@"image"];
        tattoomasterCell.gender = [object objectForKey:@"Gender"];
        tattoomasterCell.tel = [object objectForKey:@"Tel"];
        tattoomasterCell.email = [object objectForKey:@"Email"];
        tattoomasterCell.address = [object objectForKey:@"Address"];
        tattoomasterCell.latitude = [object objectForKey:@"Latitude"];
        tattoomasterCell.longitude = [object objectForKey:@"Longitude"];
        tattoomasterCell.website = [object objectForKey:@"Website"];
        tattoomasterCell.personage = [object objectForKey:@"Personage"];
         tattoomasterCell.master_id = [object objectForKey:@"Master_id"];
        tattoomasterCell.imageFile = [object objectForKey:@"image"];
        tattoomasterCell.gallery_m1 = [object objectForKey:@"Gallery_M1"];
        tattoomasterCell.object_id = object.objectId;
    
        destViewController.tattoomasterCell = tattoomasterCell;
        
    }
}


@end
