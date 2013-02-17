//
//  KZBranchOutGameViewController.h
//  BranchOut
//
//  Created by Kazuhito Ochiai on 2/15/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "BranchOutGame.h"
#import "KZRankingViewController.h"

@interface KZBranchOutGameViewController : UIViewController<UIAlertViewDelegate, BranchOutGameDelegate,KZRankingViewControllerDelegate>

@property(retain, nonatomic) IBOutlet UIProgressView *progressView;
@property(retain, nonatomic) IBOutlet UILabel *progressLabel;
@property (retain, nonatomic) IBOutletCollection(FBProfilePictureView) NSArray *currentCandidatesImageView;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *currentCandidatesNameLabel;

@end
