//
//  BranchOutGame.h
//  BranchOut
//
//  Created by Kazuhito Ochiai on 2/15/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BODeck.h"

@protocol BranchOutGameDelegate;

@interface BranchOutGame : NSObject


@property (assign, nonatomic) id<BranchOutGameDelegate> delegate;

/*total number of selection*/
@property  (readonly, nonatomic) NSUInteger totalRound;

/*current number of selection*/
@property  (readonly, nonatomic) NSUInteger currentRound;

/*Cards currently displayed*/
@property (readonly, nonatomic) NSMutableArray *currentCandidates;

/* designated initializer */
-(id)init;

/* creates hand by selecting random candidates from deck */
-(id)initWithDeck:(BODeck *)deck totalRound:(NSUInteger)round;

/* move to next round if gameFinished = NO */
-(void)nextRound;

/* change current candidate to new ones 
   does not increment current count     */
-(void)skipRound;

/* recreate hand */
-(void)reset;

/* increment selected candidate's score*/
-(void)candidateSelectedAtIndex:(NSUInteger)index;

@end

@protocol BranchOutGameDelegate

/* notifies when game is finished with ranking array.*/
-(void)branchOutGameDidFinish:(NSArray *)ranking;
@end
