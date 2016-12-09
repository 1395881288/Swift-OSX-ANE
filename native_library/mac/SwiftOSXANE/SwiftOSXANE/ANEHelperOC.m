//
//  ANEHelper.m
//  SwiftOSXANE
//
//  Created by Eoin Landy on 05/12/2016.
//  As this file is heavily influenced by code produced DiaDraw I have retained their copyright
//
//
//  Created by Radoslava Leseva on 05/06/2015.
//  Copyright (c) 2015 DiaDraw. All rights reserved.
//


#import "ANEHelperOC.h"
#include <Adobe AIR/Adobe AIR.h>

@interface ANEHelperOC ()
- (BOOL) isFREResultOK:(FREResult)errorCode ErrMessage:(NSString *)errMessage;
- (NSNumber *) getNSNumberFromFREObject:(FREObject)freObject;
- (NSString *) getNSStringFromFREObject:(FREObject)value;
- (uint32_t) getArrayLengthFromFREObject:(FREObject)freObject;
- (NSArray *) getNSArrayFromFREObject:(FREObject)freObject;
@end



@implementation ANEHelperOC

- (BOOL) isFREResultOK:(FREResult)errorCode ErrMessage:(NSString *)errMessage {
    if (FRE_OK == errorCode)
        return YES;
    NSString *messageToReport = [NSString stringWithFormat:@"%@ %d", errMessage, errorCode];
    NSLog(@"%@", messageToReport);
    return NO;
}



- (void) trace:(NSString *)value {
    FREDispatchStatusEventAsync(self.ctx, (uint8_t *) [value UTF8String], (uint8_t *) "TRACE");
}



/*******************************************************************/

- (uint32_t) getUInt32:(FREObject)freObject {
    assert( NULL != freObject );
    uint32_t result = 0;
    FREResult status = FREGetObjectAsUint32( freObject, &result );
    [self isFREResultOK:status ErrMessage:@"Could not convert FREObject to UInt32."];
    return result;
}

- (uint32_t) getArrayLengthFromFREObject:(FREObject)freObject {
    FREObject valueAS = NULL;
    FREGetObjectProperty(freObject, (const uint8_t *)"length", &valueAS, NULL);
    return [self getUInt32:valueAS];
}

- (NSArray *) getNSArrayFromFREObject:(FREObject)freObject {
    assert( NULL != freObject );
    FREObjectType objectType = FRE_TYPE_NULL;
    FREGetObjectType( freObject, &objectType );
    uint32_t arrayLength = [self getArrayLengthFromFREObject:freObject];
    NSMutableArray * result = [ NSMutableArray arrayWithCapacity: arrayLength ];
    for ( int i = 0; i < arrayLength; ++i ) {
        FREObject objAS = NULL;
        FREGetArrayElementAt( freObject, i, &objAS );
        if(NULL != freObject){
            id obj = [self getIdObjectFromFREObject:objAS];
            if(NULL != obj){
                [result addObject:obj];
            }
        }
    }
    return result;
}

-(NSNumber *) getNSNumberFromFREObject:(FREObject)freObject {
    assert( NULL != freObject );
    double val = 0.0;
    FREResult status = FREGetObjectAsDouble( freObject, &val );
    [self isFREResultOK:status ErrMessage:@"Could not convert FREObject to NSNumber."];
    return [ NSNumber numberWithDouble: val ];
}

- (NSString *) getNSStringFromFREObject:(FREObject)value {
    NSString *ret = NULL;
    uint32_t strLength = 0;
    const uint8_t *arg = NULL;
    FREResult status = FREGetObjectAsUTF8(value, &strLength, &arg);

    if (![self isFREResultOK:status ErrMessage:@"Could not convert NSString to FREObject."] || (0 >= strLength) || (NULL == arg)) {
        return NULL;
    }
    ret = [ NSString stringWithUTF8String:(const char *) arg ];
    return ret;
}

- (FREObject) getFREObjectProperty:(FREObject) freObject PropertyName:(NSString *)propertyName {
    assert( NULL != propertyName );
    assert( NULL != freObject );
    
    FREObject valueAS = NULL;
    FREObject thrownException = NULL;
    uint8_t *cString = (uint8_t *)propertyName.UTF8String;
    FREResult status = FREGetObjectProperty( freObject, cString, &valueAS, &thrownException );
    if (![self isFREResultOK:status ErrMessage:@"Could not get FREObject property."]) {
        return NULL;
    }
    return valueAS;
}

- (id) getIdObjectFromFREObject:(FREObject)objectAS  {
    FREObjectType objectType = FRE_TYPE_NULL;
    FREGetObjectType( objectAS, &objectType );
    
    switch ( objectType ) {
        //TODO remaining
        case FRE_TYPE_VECTOR:case FRE_TYPE_ARRAY: {
            return NULL;
        }
            
        case FREObjectType_ENUMPADDING: {
            return NULL;
        }
            
        case FRE_TYPE_OBJECT: {
            FREObject result = NULL;
            if(FRE_OK == FRECallObjectMethod(objectAS, (const uint8_t *)"getPropNames", 0, NULL, &result, NULL)){
                NSArray *paramNames = [self getNSArrayFromFREObject:result];
                NSMutableDictionary * dict = [ NSMutableDictionary dictionaryWithCapacity: paramNames.count ];
                for ( int i = 0; i < paramNames.count; ++i ) {
                    id key = paramNames[i];
                    FREObject propVal = NULL;
                    propVal = [self getFREObjectProperty:objectAS PropertyName:key ];
                    id val = [self getIdObjectFromFREObject:propVal];
                    [ dict setObject: val forKey: key ];
                }
                return dict;
            }
            return NULL;
        }
            
        case FRE_TYPE_BITMAPDATA: {
            return NULL;
        }
            
        case FRE_TYPE_BYTEARRAY: {
            return NULL;
        }
            
        case FRE_TYPE_NULL: {
            return NULL;
        }
        case FRE_TYPE_BOOLEAN: {
            uint32_t value = 0;
            FREGetObjectAsBool( objectAS, &value );
            return value ? @YES : @NO;
        }

        case FRE_TYPE_NUMBER: {
            return [self getNSNumberFromFREObject:objectAS];
        }

        case FRE_TYPE_STRING: {
            return [self getNSStringFromFREObject:objectAS];
        }




    }
    return NULL;
}

- (NSArray *) getNSArrayFromArgc:(uint32_t) argc Argv:(FREObject [])argv{
    NSMutableArray * argsArray = [ NSMutableArray arrayWithCapacity: argc ];
    for (int i = 0; i < argc; ++i) {
        //NSLog(@"adding");
        FREObject freObject;
        freObject = argv[i];

        id myID;
        myID = [self getIdObjectFromFREObject:freObject];
        if(myID != NULL) {
            [argsArray addObject:myID];
        }
        
    }
    NSArray *array = [argsArray copy];
    return array;
}

@end

//@end
