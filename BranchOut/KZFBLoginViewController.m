//
//  KZFBLoginViewController.m
//  BranchOut
//
//  Created by Kazuhito Ochiai on 2/15/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import "KZFBLoginViewController.h"
#import "KZAppDelegate.h"

@interface KZFBLoginViewController ()

@end

@implementation KZFBLoginViewController

-(IBAction)performLogin:(UIButton *)sender{
    
    KZAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
