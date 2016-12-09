//
//  Person.m
//  SwiftOSXANE
//
//  Created by User on 05/12/2016.
//  Copyright © 2016 Tua Rua Ltd. All rights reserved.
//

#import "Person.h"

@interface Person ()
@property (nonatomic) double bankAccount;
@property (nonatomic) double itemAmount;
@end

@implementation Person
//- means method of object
// + is static function!
-(void) testFunc {
    self.firstName = @"Bob";
    
    _firstName = @"Jack"; //direct access to private
    
    isInsecure = YES; //set private no _
    
    
    [self setLastName:@"Cork"]; //access setter
    NSString *name = [self firstName]; //access getter
    
}

/*
 
 func canPurcahse(amount:Double) {
 if bankAccount >- amount {
    return true
 }
    return false
 }
 */

- (BOOL) canPurchase:(double)amount{
    if(self.bankAccount >= amount){
        return YES;
    }
    return NO;
}

-(void) declareWinnerWithPlayerAScore:(NSInteger) scoreA playerBScore:(NSInteger)scoreB{
    
    if(scoreA > scoreB){
        NSLog(@"Player A wins");
        
    } else if (scoreB > scoreA){
        NSLog(@"Player B wins");
    }else{
        NSLog(@"Tie");
    }
}


- (void)playground {
    [self declareWinnerWithPlayerAScore:55 playerBScore:66];
}


@end
