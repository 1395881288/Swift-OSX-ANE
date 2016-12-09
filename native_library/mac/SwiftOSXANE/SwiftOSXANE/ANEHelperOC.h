//
//  ANEHelper.h
//  SwiftOSXANE
//
//  Created by Eoin Landy on 05/12/2016.
//  As this file is heavily influenced by code produced DiaDraw I have retained their copyright
//
//
//  Created by Radoslava Leseva on 05/06/2015.
//  Copyright (c) 2015 DiaDraw. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <Adobe AIR/Adobe AIR.h>

@interface ANEHelperOC : NSObject
@property (nonatomic) FREContext ctx;

- (void)trace:(NSString *)value;
- (id) getIdObjectFromFREObject:(FREObject)objectAS;
- (NSArray *)getNSArrayFromArgc:(uint32_t)argc Argv:(FREObject[])argv;
@end
