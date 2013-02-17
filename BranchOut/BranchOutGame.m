//
//  BranchOutGame.m
//  BranchOut
//
//  Created by Kazuhito Ochiai on 2/15/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import "BranchOutGame.h"

@interface BranchOutGame()

/* random set of candidates. Next candidates are last 2 objects of hand. */
@property (readonly, nonatomic) NSMutableArray *hand;
@property (retain, nonatomic) BODeck *deck;
@property (nonatomic) NSUInteger cardCount;

@end

@implementation BranchOutGame
@synthesize hand = _hand;
@synthesize currentRound = _currentRound;
@synthesize totalRound = _totalRound;
@synthesize currentCandidates = _currentCandidates;
@synthesize deck = _deck;
@synthesize cardCount = _cardCount;


-(NSMutableArray*)hand{
    
    if(!_hand) _hand = [[NSMutableArray alloc] init];
    
    return _hand;
}

-(void)setHand:(NSMutableArray *)hand{
    _hand = hand;
}

-(void)setCurrentCandidates:(NSMutableArray *)currentCandidates{
    _currentCandidates = currentCandidates;
}

-(NSMutableArray *)currentCandidates{
    
    if(!_currentCandidates){
        _currentCandidates = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _currentCandidates;
}

-(void)setCurrentRound:(NSUInteger)currentRound{
    _currentRound = currentRound;
}

-(id)init{
    
    self = [super init];
    if(self){
        _currentRound = 1;
    }
    return self;
}

-(id)initWithDeck:(BODeck *)deck totalRound:(NSUInteger)round{
    
    if(round == 0){
        NSLog(@"[BranchOutGame initWithDeck:]:total round cannot be 0.");
        self = nil;
    }
    
    else{
        self = [self init];
        
        if(self){
            self.deck = deck;
            _totalRound = round;
            self.cardCount = [deck count];
            [self selectHandFromDeck:[[deck copy] autorelease]];
            [self selectCandidates];
        }
    }
    
    return self;
}

- (void)dealloc {
    [_hand release];
    [_currentCandidates release];
    [_deck release];
    [super dealloc];
}

//select totalRound + 1 random cards from deck. 
-(void)selectHandFromDeck:(BODeck *)deck{
    
    //For the case of totalRound == 1, add 1
    for(int i=0; i < self.totalRound+1;){
        
        if(i < self.cardCount){
            BOCard* card = [deck drawRandomCard];
            if(card){
                [self.hand addObject:card];
                i++;
            }
        }
        else{
            break;
        }
    }
    
}

-(void)selectCandidates{

    //choose two candidates from hand
    BOCard *firstCandidate = [self.hand lastObject];
    self.currentCandidates[0] = firstCandidate;
    [self.hand removeLastObject];
  
    BOCard *secondCandidate = [self.hand lastObject];
    self.currentCandidates[1] = secondCandidate;
    [self.hand removeLastObject];
    
}

/* returns hand sorted by score in descending order */
-(NSArray *)getRanking{
    
        NSArray *sortedArray = [self.hand sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger first = ((BOCard*)a).score;
        NSInteger second = ((BOCard*)b).score;
        if ( first > second ) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ( first < second ) {
            return (NSComparisonResult)NSOrderedDescending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
        }];
    
        return sortedArray;
    
}

/* move to next round. */
-(void)nextRound{
    
    if(++_currentRound >= self.totalRound+1){  //notify delegate that game is done. 
        [self.delegate branchOutGameDidFinish:[self getRanking]];
    }
    else{
        [self selectCandidates];  //select new candidates
    }
}

/* change current candidate to new ones
 does not increment current count     */
-(void)skipRound{
    
    [self insertCandidatesBackToHand];  //put candidates back to random locations in hand
    [self selectCandidates]; //select new candidates

}

/* recreate hand */
-(void)reset{
    
    self.currentRound = 1;          //reset current round
    
    [self.currentCandidates release]; //reset candidate array
    self.currentCandidates = nil;  
    
    for(BOCard *c in self.hand){
        [c resetScore];             //reset card scores
    }
    
    [self.hand release];            
    self.hand = nil;
    [self selectHandFromDeck:[[self.deck copy] autorelease]];  //reset hand using new deck
    
    [self selectCandidates];

}

/* increment selected candidate's score*/
-(void)candidateSelectedAtIndex:(NSUInteger)index{
    
   // NSLog(@"%@, index:%d",((BOCard *)self.currentCandidates[index]).name,index);
    [((BOCard *)self.currentCandidates[index]) addScore:1];
    
    //mark current candidates as once displayed
    BOCard *firstCandidate = self.currentCandidates[0];
    BOCard *secondCandidate = self.currentCandidates[1];
    firstCandidate.displayedOnce = YES;      
    secondCandidate.displayedOnce = YES;
    
    [self insertCandidatesBackToHand];

}

//insert  candidate cards back to random location in hand
-(void)insertCandidatesBackToHand{
    
    BOCard *firstCandidate = self.currentCandidates[0];
    unsigned randomNum = arc4random();
    NSUInteger baseIndex = ([self.hand count]+1);
    unsigned idx = randomNum % baseIndex;
    
    //NSLog(@"[0] idx:%u, random:%d, handCont:%d",idx, randomNum,baseIndex);

    [self.hand insertObject:firstCandidate atIndex:idx];

    
    BOCard *secondCandidate = self.currentCandidates[1];
    randomNum = arc4random();
    idx = randomNum % baseIndex;
    
    // NSLog(@"[1] idx:%u, random:%d, handCont:%d",idx, randomNum,baseIndex);
    // NSLog(@"handcount:%d",[self.hand count]);
    
    [self.hand insertObject:secondCandidate atIndex:idx];
}

@end
