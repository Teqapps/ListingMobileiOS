//
//  news_detail_ViewController.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 5/11/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

#import "news_detail_ViewController.h"

@interface news_detail_ViewController ()

@end

@implementation news_detail_ViewController

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
    _news_detail.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
      _news_detail.layer.cornerRadius=8.0f;
     _news_detail.layer.borderWidth=1.0f;
     _news_detail.layer.borderColor =[[UIColor grayColor] CGColor];
    //  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.view.backgroundColor =[UIColor blackColor];
    CGRect frame =   _news_detail.frame;
    frame.size.height =  _news_detail.contentSize.height;
    _news_detail.frame = frame;
    [  _news_detail sizeToFit];
    [self.news_detail setScrollEnabled:YES];

    if (self.tattoomasterCell.news_view ==nil) {
        self.view_count.text = @"1";
    }
    else{
        self.view_count.text =[NSString stringWithFormat:@"%lu",(unsigned long)self.tattoomasterCell.news_view.count];
    }
    self.name.text =self.tattoomasterCell.name;
    _news_detail.text=self.tattoomasterCell.news;
    self.profile_image.file=self.tattoomasterCell.imageFile;
    self.profile_image.layer.cornerRadius =self.profile_image.frame.size.width / 2;
    self.profile_image.layer.borderWidth = 0.0f;
    self.profile_image.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profile_image.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
