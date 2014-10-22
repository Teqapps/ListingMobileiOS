//
//  ImageExampleCell.h
//  ParseExample
//
//  Created by Nick Barrowclough on 7/25/13.
//  Copyright (c) 2013 Nicholas Barrowclough. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface ImageExampleCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *parseImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (nonatomic, strong) NSIndexPath *clickindexpath; // name of recipe
@property (nonatomic, strong) NSString *master_name; // name of recipe
@property (nonatomic, strong) NSString *gender; // name of recipe
@property (nonatomic, strong) NSString *tel; // name of recipe
@property (nonatomic, strong) NSString *email; // name of recipe
@property (nonatomic, strong) NSString *address; // name of recipe
@property (nonatomic, strong) NSString *latitude; // name of recipe
@property (nonatomic, strong) NSString *longitude; // preparation time
@property (nonatomic, strong) NSString *website; // preparation time
@property (nonatomic, strong) NSString *personage; // preparation time
@property (nonatomic, strong) NSString *master_id; // preparation time
@property (nonatomic, strong) NSString *object_id; // preparation time
@property (nonatomic, strong) NSArray *favorites; // preparation time
@property (nonatomic, strong) NSArray *bookmark; // preparation time
@property (nonatomic, strong) NSString *description; // name of recipe
@property (nonatomic, strong) PFFile *master_promotion; // image of recipe
@property (nonatomic, strong) NSString *news; // image of recipe
@property (nonatomic, strong) PFFile *imageFile; // image of recipe
@property (nonatomic, strong) PFFile *gallery_m1; // image of gallery1
@property (nonatomic, strong) PFFile *gallery_2; // image of gallery2
@property (nonatomic, strong) PFFile *gallery_3; // image of gallery3
@property (nonatomic, strong) PFFile *gallery_4; // image of gallery4
@property (nonatomic, strong) PFFile *gallery_5; // image of gallery5
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;
@end
