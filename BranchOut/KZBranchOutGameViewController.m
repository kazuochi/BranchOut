//
//  KZBranchOutGameViewController.m
//  BranchOut
//
//  Created by Kazuhito Ochiai on 2/15/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import "KZBranchOutGameViewController.h"
#import "KZFBLoginViewController.h"
#import "BODeck.h"
#import "BOCard.h"
#import "KZRankingViewController.h"

@interface KZBranchOutGameViewController ()
@property (retain, nonatomic) BranchOutGame* branchOutGame;
@property (retain, nonatomic) IBOutlet UIView* boContainerView;
@property (retain, nonatomic) IBOutlet UILabel* titleLabel;
@end

#define kNumRound 10  //number of total round
@implementation KZBranchOutGameViewController
@synthesize progressLabel = _progressLabel;
@synthesize progressView = _progressView;
@synthesize branchOutGame = _branchOutGame;
@synthesize currentCandidatesImageView = _currentCandidatesImageView;
@synthesize currentCandidatesNameLabel = _currentCandidatesNameLabel;
@synthesize boContainerView = _boContainerView;
@synthesize titleLabel = _titleLabel;

- (void)dealloc {
    
    [_progressLabel release];
    [_progressView release];
    [_branchOutGame release];
    [_currentCandidatesImageView release];
    [_currentCandidatesNameLabel release];
    [_boContainerView release];
    [_titleLabel release];
    [super dealloc];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.view.userInteractionEnabled = NO;
    //if session is open, start preparing for the game. 
    if (FBSession.activeSession.isOpen && !self.branchOutGame) {
        [self populateDeck];
    }
    else if(self.branchOutGame){
        [self updateUI];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    
    //Display login view if session is not open.
    if (!FBSession.activeSession.isOpen) {
        
        KZFBLoginViewController* loginViewController =[[[KZFBLoginViewController alloc]initWithNibName:@"KZFBLoginViewController" bundle:nil] autorelease];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
 
}

//Populate a deck of Facebook friends info. Start game after deck is populated.
- (void)populateDeck {
    
    if (FBSession.activeSession.isOpen) {
       
        BODeck *deck = [[[BODeck alloc] init] autorelease];
        
        //get facebook friends info.
        [[FBRequest requestForMyFriends] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *result,
           NSError *error) {
             if (!error) {
                 NSArray* friends = [result objectForKey:@"data"];
                 
                 //create a card with Facebook info and add to the deck. [deck count] == number of Facebook friends
                 for (NSDictionary<FBGraphUser>* friend in friends) {
                     if(friend){
                         BOCard *card = [[[BOCard alloc] initWithId:friend.id andName:friend.name] autorelease];
                         if(card){
                             [deck addCard:card atTop:YES];
                         }
                     }
                 }
                 [self startBranchOutWithDeck:deck];  //start game when dack is populated.
             }
         }];
    }

}

-(void)startBranchOutWithDeck:(BODeck *)deck{
    
    //start game if deck has more than two cards.
    if([deck count] >= 2){
        self.branchOutGame = [[[BranchOutGame alloc] initWithDeck:deck totalRound:kNumRound] autorelease];
        self.branchOutGame.delegate = self;
        [self updateUI];
        
    }
    
    else{
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@""
                                                         message:@"You need more than two friends to play this game"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] autorelease];
        alert.tag = 2;
        [alert show];
    }
}

/* move to next round with animations*/
-(void)nextRound:(BOOL)nextRound withLeaveAnimation:(NSTimeInterval)leaveDuration andInAnimation:(NSTimeInterval)inDuration
{
    
    if(nextRound){
        [self.branchOutGame nextRound];
    }
    
    /*To-Do make another function for this block*/
    CGRect initialPos = self.boContainerView.frame;
    
    [UIView transitionWithView:self.boContainerView duration:leaveDuration options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        for (int i = 0; i<[self.currentCandidatesImageView count];i++){
            ((FBProfilePictureView *)self.currentCandidatesImageView[i]).alpha = 0.0;
        }
        self.boContainerView.frame = CGRectMake((0-self.view.frame.size.width), self.boContainerView.frame.origin.y , self.boContainerView.frame.size.width, self.boContainerView.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        [self updateUI];
        
        self.boContainerView.frame = CGRectMake(self.view.frame.size.width, self.boContainerView.frame.origin.y , self.boContainerView.frame.size.width, self.boContainerView.frame.size.height);
        
        [UIView animateWithDuration:inDuration animations:^{
            
            for (int i = 0; i<[self.currentCandidatesImageView count];i++){
                ((FBProfilePictureView *)self.currentCandidatesImageView[i]).alpha = 1.0;
            }
            
            self.boContainerView.frame = initialPos;
        }];
    }];
    
}

-(void)resetGame{
    
    [self.branchOutGame reset];
    [self updateUI];
    
}

-(void)updateUI{
    
    if(!self.view.userInteractionEnabled){
        self.view.userInteractionEnabled = YES;
    }
    
    self.titleLabel.text = @"WHO'S MORE FUN?";
    self.progressLabel.text = [self createProgressString];  //set progress label
    self.progressView.progress = (float)self.branchOutGame.currentRound / self.branchOutGame.totalRound; //set progressview's float value
    
    for(int i=0; i<[self.branchOutGame.currentCandidates count]; i++){  //update picture and label
        ((FBProfilePictureView *)self.currentCandidatesImageView[i]).profileID =  ((BOCard *)self.branchOutGame.currentCandidates[i]).id;
        
        ((UILabel *)self.currentCandidatesNameLabel[i]).text =  ((BOCard *)self.branchOutGame.currentCandidates[i]).name;
    }
    
    /* orientation support */
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSUInteger index = [viewControllers indexOfObject:self];
    
    //if actual orientation is landscape but portrait view is on schreen, push landscape view
    if(  ((self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)) && (index == 0)  ){
        
        [self pushLandscapeView];
    
    }
    //if actual orientation is portrait but landscape view is on screen, pop landscape view
    else  if(  ((self.interfaceOrientation == UIInterfaceOrientationPortrait) || (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) && (index >= 1)  ){
        
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

-(NSString *)createProgressString{
    
    NSString* progressString = [NSString stringWithFormat:@"%d",self.branchOutGame.currentRound];
    return [progressString stringByAppendingFormat:@"/%d",self.branchOutGame.totalRound];  //@"currentround/totalround"
    
}

#pragma mark - UIGestureRecognizer action
-(IBAction)candidateSelected:(UITapGestureRecognizer *)sender{
    
    //increment selected candidate's score
    if(sender.view.tag == 0){
        [self.branchOutGame candidateSelectedAtIndex:0];  
    }
    else if(sender.view .tag == 1){
        [self.branchOutGame candidateSelectedAtIndex:1];
    }
    
    [self nextRound:YES withLeaveAnimation:0.3 andInAnimation:0.5];
    
}

//skip round. Move to next round without updating score and current round count.
-(IBAction)swipeDetected:(UISwipeGestureRecognizer *)sender{
    
    [self.branchOutGame skipRound];
    [self nextRound:NO withLeaveAnimation:0.3 andInAnimation:0.5];
    
}

#pragma mark - motion detection
/*enabling shake detection*/
-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        UIAlertView *logOutAlert = [[[UIAlertView alloc] initWithTitle:@"Log Out" message:@"Log out from Facebook?" delegate:self   cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log out",nil] autorelease];
            [logOutAlert show];
        logOutAlert.tag = 1;
    
    }
}

#pragma mark - rotation support
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //if orientation is chaged to portrait && currently displaying portrait view, push landscape view
    if( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) && ([self.navigationController.viewControllers indexOfObject:self] == 0) )
    {
        [self pushLandscapeView];
    }
    else
    {
        
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

-(void)pushLandscapeView{
    
    KZBranchOutGameViewController *landscapeView = [[[KZBranchOutGameViewController alloc] initWithNibName:@"KZBranchOutGameViewController-landscape" bundle:nil] autorelease];
    landscapeView.branchOutGame = self.branchOutGame;
    
    [self.navigationController pushViewController:landscapeView animated:NO];
}

#pragma mark - UIAlertViewDelegate method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //user shaked to logout
    if(alertView.tag == 1){
        if(buttonIndex == 1){
            [self logout];
        }
    }
    
    //log out when deck is less than 2.
    else if(alertView.tag == 2){
            [self logout];
    }
}

-(void)logout {
    
    [self resetGame];
    [FBSession.activeSession closeAndClearTokenInformation];
    
}

#pragma mark - BranchOutGameDelegate method
-(void)branchOutGameDidFinish:(NSArray *)ranking{
    
    KZRankingViewController *rankingViewController = [[[KZRankingViewController alloc] initWithNibName:@"KZRankingViewController" bundle:nil] autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:rankingViewController] autorelease];
    [navController setNavigationBarHidden:YES];
    
    rankingViewController.rankingArray = ranking;
    rankingViewController.delegate = self;
    
    if((self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) )
    {
        KZRankingViewController* rankingViewControllerLandscape = [[[KZRankingViewController alloc] initWithNibName:@"KZRankingViewController-landscape" bundle:nil] autorelease];
        rankingViewControllerLandscape.rankingArray = ranking;
        rankingViewControllerLandscape.delegate = self;
        
        [navController pushViewController:rankingViewControllerLandscape animated:NO];
    }
    
    
    
    [self presentViewController:navController animated:YES completion:nil];
}


#pragma - mark KZRankingViewControllerDelegate method
-(void)rankingViewDidFifnish{
    
    [self resetGame];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
