//
//  KZRankingViewController.m
//  BranchOut
//
//  Created by Kazuhito Ochiai on 2/16/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import "KZRankingViewController.h"
#import "BOCard.h"
@interface KZRankingViewController ()

@end

@implementation KZRankingViewController
@synthesize rankingNameLabels = _rankingNameLabels;
@synthesize scoreLabels = _scoreLabels;
@synthesize rankingArray = _rankingArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for(int i = 0; i<[self.rankingArray count]; i++){
        
        //ranking only support up to 10 cards
        if(i==10){
            break;
        }
        if([self.rankingArray[i] isMemberOfClass:[BOCard class]]){
            BOCard *card = (BOCard*)self.rankingArray[i];
            ((UILabel *)self.rankingNameLabels[i]).text = card.name;
            
            NSString *scoreStr = nil;
            if (card.score > 1){
                scoreStr = [NSString stringWithFormat:@"%d pts",card.score];
            }
            else{
                scoreStr = [NSString stringWithFormat:@"%d pt",card.score];
            }
            
            ((UILabel *)self.scoreLabels[i]).text = scoreStr;
        }
        
    }
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)doneButtonPressed:(UIButton *)sender{
    [self.delegate rankingViewDidFifnish];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_rankingNameLabels release];
    [_scoreLabels release];
    [_rankingArray release];
    [super dealloc];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        KZRankingViewController *landscapeView = [[[KZRankingViewController alloc] initWithNibName:@"KZRankingViewController-landscape" bundle:nil] autorelease];
        landscapeView.rankingArray = self.rankingArray;
        landscapeView.delegate = self.delegate;
        
        [self.navigationController pushViewController:landscapeView animated:NO];
    }
    else
    {
        
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}
@end
