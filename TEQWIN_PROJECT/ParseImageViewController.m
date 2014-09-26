//
//  ParseImageViewController.m
//  ParseExample
//
//  Created by Nick Barrowclough on 7/25/13.
//  Copyright (c) 2013 Nicholas Barrowclough. All rights reserved.
//

#import "ParseImageViewController.h"
#import "GalleryCell.h"
@interface ParseImageViewController ()

@end

@implementation ParseImageViewController

@synthesize imagesCollection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//self.count.text  = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [PFUser currentUser].username];
 
    [self queryParseMethod];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)queryParseMethod {
    NSLog(@"start query");
       NSLog(@"%@",self.tattoomasterCell.master_id);
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"master_id" equalTo:self.tattoomasterCell.master_id];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            imageFilesArray = [[NSArray alloc] initWithArray:objects];
            NSLog(@"%@", imageFilesArray);
            
            [imagesCollection reloadData];
        }
    }];
}



#pragma mark - UICollectionView data source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [imageFilesArray count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"imageCell";
    ImageExampleCell *cell = (ImageExampleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFObject *imageObject = [imageFilesArray objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"image"];
    
    cell.loadingSpinner.hidden = NO;
    [cell.loadingSpinner startAnimating];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            cell.parseImage.image = [UIImage imageWithData:data];
            [cell.loadingSpinner stopAnimating];
            cell.loadingSpinner.hidden = YES;
        }
    }];
                
    return cell;
}


//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 //   [self likeImage:[imageFilesArray objectAtIndex:indexPath.row]];
//}



//- (void) likeImage:(PFObject*)object {
    
 //   [object addUniqueObject:[PFUser currentUser].objectId forKey:@"favorites"];
    
 //   [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
 //       if (!error) {
 //           NSLog(@"liked picture!");
  //          [self likedSuccess];
  //      }
  //      else {
  //          [self likedFail];
  //      }
//}];
//}



//- (void) likedSuccess {
 //   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"You have succesfully liked the image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alert show];
//}
 


//- (void) likedFail {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:@"There was an error when liking the image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
 //   [alert show];
//}


//- (IBAction)segmentSelected:(id)sender {
 //   if (_segmentedController.selectedSegmentIndex == 0) {
 //       [self queryParseMethod];
 //   }
 //   if (_segmentedController.selectedSegmentIndex == 1) {
 //       [self retrieveLikedImages];
 //   }
//}


//- (void) retrieveLikedImages {
//    PFQuery *GetFavorites = [PFQuery queryWithClassName:@"collectionViewData"];
 //   [GetFavorites whereKey:@"favorites" equalTo:[PFUser currentUser].objectId];
    
 //   [GetFavorites findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
 //       if (!error) {
  //          imageFilesArray = [[NSArray alloc] initWithArray:objects];
  //          [imagesCollection reloadData];
 //       }
  //  }];
//}





@end
