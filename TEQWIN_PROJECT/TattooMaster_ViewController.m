//
//  TattooMaster_ViewController.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 28/7/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//
#import "ImageExampleCell.h"
#import "HomeModel.h"
#import "Tattoo_Master_Info.h"
#import "TattooMaster_ViewController.h"
#import "Master_Map_ViewController.h"
#import "Tattoo_Detail_ViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
@interface TattooMaster_ViewController ()<UISearchDisplayDelegate, UISearchBarDelegate>
{
    int lastClickedRow;
}

@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;


@end

@implementation TattooMaster_ViewController
@synthesize searchbar;
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
- (void)viewDidLoad;
{
    [super viewDidLoad];
      [self refreshTable:nil];
 
    self.title =@"師父";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];

    searchbar.hidden = !searchbar.hidden;
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
- (void)viewWillAppear:(BOOL)animated {
      [self refreshTable:nil];
    // scroll search bar out of sight
  

    
    CGRect newBounds = self.tableView.bounds;
    if (self.tableView.bounds.origin.y < 44) {
        newBounds.origin.y = newBounds.origin.y + self.searchbar.bounds.size.height;
        self.tableView.bounds = newBounds;
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self viewWillAppear:YES];
    
}

- (IBAction)showsearch:(id)sender {
    [searchbar becomeFirstResponder];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        
        return self.objects.count;
        
    } else {
        //NSLog(@"how many in search results");
        //NSLog(@"%@", self.searchResults.count);
        return self.searchResults.count;
        
    }
}

-(void)filterResults:(NSString *)searchTerm scope:(NSString*)scope
{
    
    [self.searchResults removeAllObjects];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Tattoo_Master"];
    //[query whereKey:@"Name" containsString:searchTerm];
    query.cachePolicy=kPFCachePolicyCacheElseNetwork;
    NSArray *results  = [query findObjects];
    NSLog(@"%d",results.count);
    
    [self.searchResults addObjectsFromArray:results];
    
    NSPredicate *searchPredicate =
    [NSPredicate predicateWithFormat:@"Name CONTAINS[cd]%@", searchTerm];
    _searchResults = [NSMutableArray arrayWithArray:[results filteredArrayUsingPredicate:searchPredicate]];
    
   // if(![scope isEqualToString:@"全部"]) {
        // Further filter the array with the scope
     //   NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"Gender contains[cd] %@", scope];
       
      //  _searchResults = [NSMutableArray arrayWithArray:[_searchResults filteredArrayUsingPredicate:resultPredicate]];
    }//}

//當search 更新時， tableview 就會更新，無論scope select 咩
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchTerm
{
    [self filterResults :searchTerm
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
//當scope 更新時，tableview 就會更新 （但要有search text)
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//{
    // Tells the table data source to reload when scope bar selection changes
 //    [self filterResults :[self.searchDisplayController.searchBar text] scope:
 //    [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
 //   return YES;
//}

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
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
       
    }
  
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    /*    if ([self.objects count] == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }*/
    
    [query orderByAscending:@"createdAt"];
    
    return query;
    
}






- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        
        selectobject = [self.objects  objectAtIndex:indexPath.row];
        NSLog(@"%@",[selectobject objectForKey:@"Master_id"]);
    } else {
        //NSLog(@"how many in search results");
        //NSLog(@"%@", self.searchResults.count);
        
                selectobject = [_searchResults  objectAtIndex:indexPath.row];
        NSLog(@"%@",[selectobject objectForKey:@"Master_id"]);
        Tattoo_Detail_ViewController * mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Tattoo_Detail_ViewController"];
         [self.navigationController pushViewController:mapVC animated:YES];
        TattooMasterCell * tattoomasterCell = [[TattooMasterCell alloc] init];
        tattoomasterCell.object_id = [selectobject objectForKey:@"object"];
        tattoomasterCell.favorites = [selectobject objectForKey:@"favorites"];
        tattoomasterCell.name = [selectobject objectForKey:@"Name"];
        tattoomasterCell.imageFile = [selectobject objectForKey:@"image"];
        tattoomasterCell.gender = [selectobject objectForKey:@"Gender"];
        tattoomasterCell.tel = [selectobject objectForKey:@"Tel"];
        tattoomasterCell.email = [selectobject objectForKey:@"Email"];
        tattoomasterCell.address = [selectobject objectForKey:@"Address"];
        tattoomasterCell.latitude = [selectobject objectForKey:@"Latitude"];
        tattoomasterCell.longitude = [selectobject objectForKey:@"Longitude"];
        tattoomasterCell.website = [selectobject objectForKey:@"Website"];
        tattoomasterCell.personage = [selectobject objectForKey:@"Personage"];
        tattoomasterCell.master_id = [selectobject objectForKey:@"Master_id"];
        tattoomasterCell.imageFile = [selectobject objectForKey:@"image"];
        tattoomasterCell.gallery_m1 = [selectobject objectForKey:@"Gallery_M1"];
        tattoomasterCell.object_id = selectobject.objectId;

         mapVC.tattoomasterCell = tattoomasterCell;
        NSLog(@"%@",tattoomasterCell.master_id);
    }
    
    
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
    static NSString *simpleTableIdentifier = @"RecipeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell
    // Configure the cell
    
    if (tableView == self.tableView) {
     
        
        
        
        
        
        UIActivityIndicatorView *loadingSpinner = (UIActivityIndicatorView*) [cell viewWithTag:110];
        loadingSpinner.hidden= NO;
        [loadingSpinner startAnimating];
        
        PFFile *thumbnail = [object objectForKey:@"image"];
        PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
        
      
        thumbnailImageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
        thumbnailImageView.layer.cornerRadius= thumbnailImageView.frame.size.width / 2;
        thumbnailImageView.layer.borderWidth=0.0;
        thumbnailImageView.layer.masksToBounds = YES;
        thumbnailImageView.layer.borderColor=[[UIColor whiteColor] CGColor];
     
        thumbnailImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //
        thumbnailImageView.image = [UIImage imageNamed:@"loading_image.gif"];
        thumbnailImageView.file = thumbnail;
        [thumbnailImageView loadInBackground];
        [loadingSpinner stopAnimating];
        loadingSpinner.hidden = YES;
        
              UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
        nameLabel.text = [object objectForKey:@"Name"];
        
        UILabel *prepTimeLabel = (UILabel*) [cell viewWithTag:102];
        prepTimeLabel.text = [object objectForKey:@"Gender"];
        
        count=[object objectForKey:@"favorites"];
        UILabel *count_like = (UILabel*) [cell viewWithTag:105];
        count_like.text = [NSString stringWithFormat:@"%d",count.count];
        
        heart_statues = (PFImageView*)[cell viewWithTag:107];
        if ([[object objectForKey:@"favorites"]containsObject:[PFUser currentUser].objectId]) {
            
            heart_statues.image = [UIImage imageNamed:@"button_heart_red.png"];
        }
        else
        {
            
            heart_statues.image = [UIImage imageNamed:@"button_heart_blue.png"];
        }
        // UICollectionView *cellImageCollection=(UICollectionView *)[cell viewWithTag:9];
        
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        PFObject* object = self.searchResults[indexPath.row];
        
        
        if ([[object objectForKey:@"favorites"]containsObject:[PFUser currentUser].objectId]) {
            
            cell.imageView.image = [UIImage imageNamed:@"button_heart_red.png"];
        }
        else
        {
            
            cell.imageView.image = [UIImage imageNamed:@"button_heart_blue.png"];
        }

        cell.textLabel.text = [object objectForKey:@"Name"];
        cell.detailTextLabel.text =[object objectForKey:@"Gender"];
        
    }
    
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
    if ([PFUser currentUser]) {
        UIButton *button = sender;
        CGPoint correctedPoint =
        [button convertPoint:button.bounds.origin toView:self.tableView];
        indexPath =  [self.tableView indexPathForRowAtPoint:correctedPoint];
        lastClickedRow = indexPath.row;
        selectobject = [self.objects objectAtIndex:indexPath.row];
        
        
        if ([[selectobject objectForKey:@"favorites"]containsObject:[PFUser currentUser].objectId]) {
            
            [self dislike];
            
            NSLog(@"disliked");
            
        }
        
        else{
            
            
            [self likeImage];
            
            NSLog(@"liked");
            
        }
    }
    else{
        NSLog(@"請登入")
        ; }
}
- (void) likeImage {
    [selectobject addUniqueObject:[PFUser currentUser].objectId forKey:@"favorites"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];
    [selectobject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            
            if ([[selectobject objectForKey:@"favorites"]containsObject:[PFUser currentUser].objectId]) {
                
            }
            [self refreshTable:nil];
            [hud hide:YES];
        }
        else {
            [self likedFail];
        }
    }];
}
- (void) dislike {
    [selectobject removeObject:[PFUser currentUser].objectId forKey:@"favorites"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud show:YES];
    [selectobject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            
            if ([[selectobject objectForKey:@"favorites"]containsObject:[PFUser currentUser].objectId]) {
                
            }
            else
            {
                
            }
            [self refreshTable:nil];
            [hud hide:YES];
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
        tattoomasterCell.bookmark =[object objectForKey:@"bookmark"];
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
        tattoomasterCell.description=[object objectForKey:@"description"];
        destViewController.tattoomasterCell = tattoomasterCell;
        
        
       
        
    }
    
}


@end
