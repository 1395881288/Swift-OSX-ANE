//
//  Person.h
//  SwiftOSXANE
//
//  Created by User on 05/12/2016.
//  Copyright © 2016 Tua Rua Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject {
    //private
    BOOL isInsecure;
}
@property (nonatomic,strong) NSString *firstName; //public - these create an instance variable called _firstName
@property (nonatomic,strong) NSString *lastName; //public
@end
