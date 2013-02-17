//
//  BODeck.h
//  BranchOut
//
//  Created by Kazuhito Ochiai on 2/15/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOCard.h"

@interface BODeck : NSObject

/* add card to the deck. insert at index 0 if atTop == YES; */
-(void) addCard:(BOCard *)card atTop:(BOOL)atTop;

/* return random card and remove returned card from the deck.*/
-(BOCard *)drawRandomCard;

-(NSUInteger)count;

-(void)resetScore;

@end