//
//  BOCard.m
//  BranchOut
//
//  Created by Kazuhito Ochiai on 2/15/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import "BOCard.h"

@implementation BOCard
@synthesize id = _id;
@synthesize name = _name;
@synthesize score = _score;
@synthesize displayedOnce = _displayedOnce;

-(void)setScore:(NSInteger)score{
    _score = score;
}

-(id)init{
    self = [super init];
    if(self){
        self.score = 0;
        self.displayedOnce = NO;
    }
    return self;
}

-(id)initWithId:(NSString *)id andName:(NSString *)name{
    
    self = [self init];
    
    if(self){
        self.id = id;
        self.name = name;
    }

    return self;
}

-(void)resetScore{
    self.score = 0;
}

-(void)addScore:(NSInteger)value{
    self.score = _score + value;
}
- (void)dealloc {
    
    [_id release];
    [_name release];
    [super dealloc];
}


@end
