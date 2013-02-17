//
//  KZRankingViewController.h
//  BranchOut
//
//  Created by Kazuhito Ochiai on 2/16/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KZRankingViewControllerDelegate;

@interface KZRankingViewController : UIViewController

@property (assign, nonatomic) id<KZRankingViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *rankingNameLabels;

@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *scoreLabels;

@property (retain, nonatomic) NSArray* rankingArray;

@end

@protocol KZRankingViewControllerDelegate
-(void)rankingViewDidFifnish;

@end
