//
//  BODeck.m
//  BranchOut
//
//  Created by Kazuhito Ochiai on 2/15/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import "BODeck.h"

@interface BODeck()
@property (retain, nonatomic) NSMutableArray *cards;
@end

@implementation BODeck
@synthesize cards = _cards;

-(void)dealloc{
    [_cards release];
    [super dealloc];
}

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    
    return _cards;
}

-(void) addCard:(BOCard *)card atTop:(BOOL)atTop{
    
    if(atTop){
       
        [self.cards insertObject:card atIndex:0];
        
    }
    else{
        [self.cards addObject:card];
    }
}

-(BOCard *)drawRandomCard{
    
    BOCard *randomCard = nil;
    if ([self.cards count]>0) {
        unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    return randomCard;
}

-(NSUInteger)count{
    
    return [self.cards count];
    
}

-(void)resetScore{
    for(BOCard *c in self.cards){
        [c resetScore];
    }
}

-(id)copyWithZone:(NSZone *)zone
{
    BODeck *another = [[BODeck alloc] init];
    another.cards = [[self.cards mutableCopy] autorelease];
//    NSLog(@"%d",[another.cards count]);
    return another;
}

@end
