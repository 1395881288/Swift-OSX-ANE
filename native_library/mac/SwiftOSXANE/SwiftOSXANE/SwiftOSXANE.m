//
// Created by User on 04/12/2016.
// Copyright (c) 2016 Tua Rua Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>


#include "SwiftOSXANE_oc.h"
#import "SwiftOSXANE-Swift.h"
#include <Adobe AIR/Adobe AIR.h>

SwiftController *swft;
FREContext dllContext;
#define FRE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

// convert argv into a pointer array which can be passed to Swift
NSPointerArray * getFREargs(uint32_t argc, FREObject argv[]) {
    NSPointerArray * pa = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsOpaqueMemory];
    for (int i = 0; i < argc; ++i) {
        FREObject freObject;
        freObject = argv[i];
        [pa addPointer:freObject];
    }
    return pa;
}

FRE_FUNCTION (runStringTests) {
    return [swft runStringTestsWithArgv:getFREargs(argc, argv)];
}
FRE_FUNCTION (runNumberTests) {
    return [swft runNumberTestsWithArgv:getFREargs(argc, argv)];
}
FRE_FUNCTION (runIntTests) {
    return [swft runIntTestsWithArgv:getFREargs(argc, argv)];
}
FRE_FUNCTION (runArrayTests) {
    return [swft runArrayTestsWithArgv:getFREargs(argc, argv)];
}
FRE_FUNCTION (runObjectTests) {
    return [swft runObjectTestsWithArgv:getFREargs(argc, argv)];
}

FRE_FUNCTION (runBitmapTests) {
    return [swft runBitmapTestsWithArgv:getFREargs(argc, argv)];
}

FRE_FUNCTION (runByteArrayTests) {
    return [swft runByteArrayTestsWithArgv:getFREargs(argc, argv)];
}

FRE_FUNCTION(runDataTests) {
    return [swft runDataTestsWithArgv:getFREargs(argc, argv)];
}

FRE_FUNCTION(runErrorTests) {
    return [swft runErrorTestsWithArgv:getFREargs(argc, argv)];
}



void contextInitializer(void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet) {
    static FRENamedFunction extensionFunctions[] = {
        {(const uint8_t *) "runStringTests", NULL, &runStringTests},
        {(const uint8_t *) "runNumberTests", NULL, &runNumberTests},
        {(const uint8_t *) "runIntTests", NULL, &runIntTests},
        {(const uint8_t *) "runArrayTests", NULL, &runArrayTests},
        {(const uint8_t *) "runObjectTests", NULL, &runObjectTests},
        {(const uint8_t *) "runBitmapTests", NULL, &runBitmapTests},
        {(const uint8_t *) "runByteArrayTests", NULL, &runByteArrayTests},
        {(const uint8_t *) "runErrorTests", NULL, &runErrorTests},
        {(const uint8_t *) "runDataTests", NULL, &runDataTests}
        
        
    };

    /*
     *
     * typedef struct FRENamedFunction_ {
    const uint8_t* name;
	void*          functionData;
    FREFunction    function;
} FRENamedFunction;
     */

    *numFunctionsToSet = sizeof(extensionFunctions) / sizeof(FRENamedFunction);
    *functionsToSet = extensionFunctions;
    dllContext = ctx;
    
    
    swft = [[SwiftController alloc] init];
    [swft setFREContextWithCtx:ctx];

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
