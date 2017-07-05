//
// Created by User on 04/12/2016.
// Copyright (c) 2016 Tua Rua Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>


#include "SwiftOSXANE_oc.h"
#import "SwiftOSXANE-Swift.h"
#include <Adobe AIR/Adobe AIR.h>

SwiftController *swft;
NSArray *funcArray;
#define FRE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

FRE_FUNCTION(callSwiftFunction) {
    NSString *fName = (__bridge NSString *) (functionData);
    return [swft callSwiftFunctionWithName:fName ctx:context argc:argc argv:argv];
}

void contextInitializer(void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet,
                        const FRENamedFunction **functionsToSet) {
    
    swft = [[SwiftController alloc] init];
    [swft setFREContextWithCtx:ctx];
    funcArray = [swft getFunctions];
    
    /**************************************************************************/
    /********************* DO NO MODIFY ABOVE THIS LINE ***********************/
    /**************************************************************************/
    
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    static FRENamedFunction extensionFunctions[] =
    {
        { (const uint8_t*) "runStringTests", (__bridge void *)@"runStringTests", &callSwiftFunction }
        ,{ (const uint8_t*) "runNumberTests", (__bridge void *)@"runNumberTests", &callSwiftFunction }
        ,{ (const uint8_t*) "runIntTests", (__bridge void *)@"runIntTests", &callSwiftFunction }
        ,{ (const uint8_t*) "runArrayTests", (__bridge void *)@"runArrayTests", &callSwiftFunction }
        ,{ (const uint8_t*) "runObjectTests", (__bridge void *)@"runObjectTests", &callSwiftFunction }
        ,{ (const uint8_t*) "runBitmapTests", (__bridge void *)@"runBitmapTests", &callSwiftFunction }
        ,{ (const uint8_t*) "runByteArrayTests", (__bridge void *)@"runByteArrayTests", &callSwiftFunction }
        ,{ (const uint8_t*) "runErrorTests", (__bridge void *)@"runErrorTests", &callSwiftFunction }
        ,{ (const uint8_t*) "runErrorTests2", (__bridge void *)@"runErrorTests2", &callSwiftFunction }
        ,{ (const uint8_t*) "runDataTests", (__bridge void *)@"runDataTests", &callSwiftFunction }
    };
    /**************************************************************************/
    /**************************************************************************/

    
    *numFunctionsToSet = sizeof( extensionFunctions ) / sizeof( FRENamedFunction );
    *functionsToSet = extensionFunctions;
    
    
}

void contextFinalizer(FREContext ctx) {
    return;
}

void TRSOAExtInizer(void **extData, FREContextInitializer *ctxInitializer, FREContextFinalizer *ctxFinalizer) {
    *ctxInitializer = &contextInitializer;
    *ctxFinalizer = &contextFinalizer;
}

void TRSOAExtFinizer(void *extData) {
    FREContext nullCTX;
    nullCTX = 0;
    contextFinalizer(nullCTX);
    return;
}
