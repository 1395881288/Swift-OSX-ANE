//
// Created by User on 04/12/2016.
// Copyright (c) 2016 Tua Rua Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>


#include "SwiftOSXANE_oc.h"
#import "SwiftOSXANE-Swift.h"
#include <Adobe AIR/Adobe AIR.h>

SwiftController *swft;
NSArray * funcArray;
#define FRE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

FRE_FUNCTION(callSwiftFunction) {
    NSString* fName = (__bridge NSString *)(functionData);
    return [swft callSwiftFunctionWithName:fName ctx:context argc:argc argv:argv];
}

void contextInitializer(void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet) {
    
    /******* MAKE SURE TO SET NUM OF FUNCTIONS MANUALLY *****/
    /********************************************************/
    
    const int numFunctions = 16;
    
    /********************************************************/
    /********************************************************/
    
    swft = [[SwiftController alloc] init];
    [swft setFREContextWithCtx:ctx];
    
    
    funcArray = [swft getFunctions];
    static FRENamedFunction extensionFunctions[numFunctions] = {};
    for (int i = 0; i < [funcArray count]; ++i) {
        NSString * nme = [funcArray objectAtIndex:i];
        FRENamedFunction nf = {(const uint8_t *) [nme UTF8String], (__bridge void *)(nme), &callSwiftFunction};
        extensionFunctions[i] = nf;
    }

    *numFunctionsToSet = sizeof(extensionFunctions) / sizeof(FRENamedFunction);
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
