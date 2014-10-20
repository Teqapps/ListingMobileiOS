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



@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self queryParseMethod];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.image_collection setCollectionViewLayout:flowLayout];
    flowLayout.itemSize = CGSizeMake(320, 240);

    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        self.test.text = @"hihiuser";
    } else {
        self.test.text = @"on9son";
        
    }
    int randomImgNumber = arc4random_uniform(5);
    PFObject *object = [imageFilesArray objectAtIndex:randomImgNumber];
    _main_image.file=[object objectForKey:@"image"];
    NSLog(@"goooood%d",randomImgNumber);
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

-(void)itemsDownloaded:(NSArray *)items
{
    // This delegate method will get called when the items are finished downloading
    
    // Set the downloaded items to the array
    _feedItems = items;
    
    
}

- (void)queryParseMethod {
    PFQuery *query = [PFQuery queryWithClassName:@"Tattoo_Master"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            imageFilesArray = [[NSArray alloc] initWithArray:objects];
              query.cachePolicy = kPFCachePolicyCacheThenNetwork;
           [_image_collection reloadData];
         //   NSLog(@"%@",imageFilesArray);
            
            [query orderByAscending:@"createdAt"];
            
        }
        
    }];


}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [imageFilesArray count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    static NSString *cellIdentifier = @"imageCell";
    ImageExampleCell *cell = (ImageExampleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFObject *imageObject = [imageFilesArray objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"image"];
    
    cell.loadingSpinner.hidden = NO;
    [cell.loadingSpinner startAnimating];
    UILabel *name = (UILabel*) [cell viewWithTag:150];
    name.text = [imageObject objectForKey:@"Name"];

    
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            cell.parseImage.image = [UIImage imageWithData:data];
            [cell.loadingSpinner stopAnimating];
            cell.loadingSpinner.hidden = YES;
            [ cell.parseImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)]];
            
        }
    }];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
       // Tattoo_Detail_ViewController * mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Tattoo_Detail_ViewController"];
  //   [self.navigationController pushViewController:mapVC animated:YES];
    //    mapVC.tattoomasterCell=_tattoomasterCell;
    
          //  NSLog(@"反反反反%@",[imageFilesArray_image objectAtIndex:indexPath.row]);
   // Tattoo_Detail_ViewController * mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Tattoo_Detail_ViewController"];
   // [self.navigationController pushViewController:mapVC animated:YES];
    
  //  mapVC.tattoomasterCell=_tattoomasterCell;
    NSLog(@"%@%@",self.tattoomasterCell.latitude,self.tattoomasterCell.longitude);

    NSLog(@"反反反反%d",indexPath.row);
}

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
        tattoomasterCell.imageFile = [object objectForKey:@"image"];
        tattoomasterCell.gallery_m1 = [object objectForKey:@"Gallery_M1"];
        tattoomasterCell.object_id = object.objectId;
        tattoomasterCell.description=[object objectForKey:@"description"];
         tattoomasterCell.promotion=[object objectForKey:@"promotion"];
    
        destViewController.tattoomasterCell = tattoomasterCell;
            
        NSLog(@"Haaaaa%@",tattoomasterCell.master_id);
        }
    }


@end
