//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//
#import "ImageExampleCell.h"
#import "Tattoo_Master_Info.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "Tattoo_Detail_ViewController.h"
#import "TattooMasterCell.h"
@interface MainViewController ()

{
     int lastClickedRow;
    HomeModel *_homeModel;
    NSArray *_feedItems;
    Tattoo_Master_Info *_selected_tattoo_master;
    NSArray *searchResults;
}
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;


@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
  
    // scroll search bar out of sight
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.image_collection setCollectionViewLayout:flowLayout];
    
    flowLayout.itemSize = CGSizeMake(320, 163);
    
    [flowLayout setMinimumLineSpacing:0.0f];

   // [flowLayout setMinimumLineSpacing:0.0f];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        self.test.text = @"hihiuser";
    } else {
        self.test.text = @"on9son";
        
    }
    int randomImgNumber = arc4random_uniform(5);
    PFObject *object = [imageFilesArray objectAtIndex:randomImgNumber];

    
    self.title = @"News";
self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
   }
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    
}

- (IBAction)showsearch:(id)sender {
    [_searchbar becomeFirstResponder];
      }



- (void)viewWillAppear:(BOOL)animated {
    [self queryParseMethod];
    [self queryParseMethod_news];
    searchquery = [PFQuery queryWithClassName:@"Tattoo_Master"];
    //[query whereKey:@"Name" containsString:searchTerm];
    
    searchquery.cachePolicy=kPFCachePolicyNetworkElseCache;

}
-(void)itemsDownloaded:(NSArray *)items
{
    // This delegate method will get called when the items are finished downloading
    
    // Set the downloaded items to the array
    _feedItems = items;
    
    
}
- (void)queryParseMethod_news {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud show:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Tattoo_Master"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    // [query whereKey:@"news" equalTo:self.tattoomasterCell.master_id];
    [query whereKey:@"news_approve" equalTo:[NSNumber numberWithBool:YES]];


    [query orderByDescending:@"news"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            news_array = [[NSArray alloc] initWithArray:objects];
            
          
            [_main_tableview reloadData];
            //   NSLog(@"%@",imageFilesArray);
            [hud hide:YES];
            
            NSLog(@"haha%d",news_array.count);
            
        }
        
    }];
    
    
}

- (void)queryParseMethod {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud show:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Tattoo_Master"];
    
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query whereKey:@"promotion_approve" equalTo:[NSNumber numberWithBool:YES]];
    [query orderByAscending:@"updatedAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            imageFilesArray = [[NSArray alloc] initWithArray:objects];

           [_image_collection reloadData];
           
         //   NSLog(@"%@",imageFilesArray);
            [hud hide:YES];

                    NSLog(@"%d",imageFilesArray.count);

        }

    }];


}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
      // return @"最新消息";
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor grayColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (tableView == self.main_tableview) {
        
    return [news_array count];
        
    } else {
        //NSLog(@"how many in search results");
        //NSLog(@"%@", self.searchResults.count);
        return self.searchResults.count;
        
    }
}
-(void)filterResults:(NSString *)searchTerm scope:(NSString*)scope
{

    [self.searchResults removeAllObjects];
    
    
    
    NSArray *results  = [searchquery findObjects];
    NSLog(@"%d",results.count);
    searchquery.cachePolicy=kPFCachePolicyCacheElseNetwork;
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



 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *simpleTableIdentifier = @"favcell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (tableView == self.main_tableview) {
    // Configure the cell
    // Configure the cell
    PFObject *imageObject = [news_array objectAtIndex:indexPath.row];
    PFFile *thumbnail = [imageObject objectForKey:@"image"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
    CGSize itemSize = CGSizeMake(70, 70);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    thumbnailImageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    thumbnailImageView.layer.cornerRadius=thumbnailImageView.frame.size.width/2;
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
    nameLabel.text = [imageObject objectForKey:@"Name"];
    
    UITextView *news = (UITextView*) [cell viewWithTag:155];
      
    news.text = [imageObject objectForKey:@"news"];
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



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [imageFilesArray count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellIdentifier = @"imageCell";
    ImageExampleCell *cell = (ImageExampleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.loadingSpinner.hidden = NO;
    [cell.loadingSpinner startAnimating];
    PFObject *imageObject = [imageFilesArray objectAtIndex:indexPath.row];
      PFFile *avstar = [imageObject objectForKey:@"image"];
    
    
    UILabel *name = (UILabel*) [cell viewWithTag:166];
    name.text = [imageObject objectForKey:@"Name"];
    
   
    PFFile *imageFile = [imageObject objectForKey:@"promotion"];

   // CGSize itemSize = CGSizeMake(70, 70);
   // UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    //CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    //cell.thumbnail.layer.backgroundColor=[[UIColor clearColor] CGColor];
   // cell.thumbnail.layer.cornerRadius= cell.thumbnail.frame.size.width/2;
    //cell.thumbnail.layer.borderWidth=2.0;
   // cell.thumbnail.layer.masksToBounds = YES;
   // cell.thumbnail.layer.borderColor=[[UIColor whiteColor] CGColor];
   // [ cell.thumbnail.image drawInRect:imageRect];
   // cell.thumbnail.image = UIGraphicsGetImageFromCurrentImageContext();
   // UIGraphicsEndImageContext();
    
    cell.thumbnail.image = [UIImage imageNamed:@"placeholder.jpg"];
    
    cell.thumbnail.file = avstar;
    [ cell.thumbnail loadInBackground];

  

    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            
            cell.parseImage.image = [UIImage imageWithData:data];
            [cell.loadingSpinner stopAnimating];
            cell.loadingSpinner.hidden = YES;
           
                  }
    }];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.main_tableview) {
        
        selectobject = [news_array  objectAtIndex:indexPath.row];
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

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
 //   PFObject* selectobject = [imageFilesArray  objectAtIndex:indexPath.row];
 //   NSLog(@"%@",[selectobject objectForKey:@"Master_id"]);
 //   Tattoo_Detail_ViewController * mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Tattoo_Detail_ViewController"];
 //   [self.navigationController pushViewController:mapVC animated:YES];
 //   TattooMasterCell * tattoomasterCell = [[TattooMasterCell alloc] init];
//    tattoomasterCell.object_id = [selectobject objectForKey:@"object"];
 //   tattoomasterCell.favorites = [selectobject objectForKey:@"favorites"];
  //  tattoomasterCell.bookmark = [selectobject objectForKey:@"bookmark"];
 //   tattoomasterCell.name = [selectobject objectForKey:@"Name"];
 //   tattoomasterCell.imageFile = [selectobject objectForKey:@"image"];
 //   tattoomasterCell.gender = [selectobject objectForKey:@"Gender"];
 //   tattoomasterCell.tel = [selectobject objectForKey:@"Tel"];
 //   tattoomasterCell.email = [selectobject objectForKey:@"Email"];
  //  tattoomasterCell.address = [selectobject objectForKey:@"Address"];
  //  tattoomasterCell.latitude = [selectobject objectForKey:@"Latitude"];
  //  tattoomasterCell.longitude = [selectobject objectForKey:@"Longitude"];
  //  tattoomasterCell.website = [selectobject objectForKey:@"Website"];
  //  tattoomasterCell.personage = [selectobject objectForKey:@"Personage"];
  //  tattoomasterCell.master_id = [selectobject objectForKey:@"Master_id"];
  //  tattoomasterCell.imageFile = [selectobject objectForKey:@"image"];
  //  tattoomasterCell.gallery_m1 = [selectobject objectForKey:@"Gallery_M1"];
  //  tattoomasterCell.object_id = selectobject.objectId;
    
  //  mapVC.tattoomasterCell = tattoomasterCell;
   // NSLog(@"%@",tattoomasterCell.master_id);
//}





-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"godetail"]) {
        NSIndexPath *indexPath = [self.image_collection indexPathForCell:sender];

        Tattoo_Detail_ViewController *destViewController = segue.destinationViewController;
        
        PFObject *object = [imageFilesArray objectAtIndex:indexPath.row];
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
        
        tattoomasterCell.gallery_m1 = [object objectForKey:@"Gallery_M1"];
        tattoomasterCell.object_id = object.objectId;
        tattoomasterCell.description=[object objectForKey:@"description"];
         tattoomasterCell.promotion=[object objectForKey:@"promotion"];
    
        destViewController.tattoomasterCell = tattoomasterCell;
            
        NSLog(@"Haaaaa%@",tattoomasterCell.imageFile);
        }
    }



@end
