//
// Created by User on 04/12/2016.
// Copyright (c) 2016 Tua Rua Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>


#include "SwiftOSXANE_oc.h"
#import "SwiftOSXANE-Swift.h"
#include "ANEHelperOC.h"
#include <Adobe AIR/Adobe AIR.h>

SwiftOSXANE *swft;
ANEHelperOC *aneHelper;

#define FRE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

FRE_FUNCTION (getAge) {
    return [swft getAgeWithArgv:[aneHelper getNSArrayFromArgc:argc Argv:argv]];
}

FRE_FUNCTION(getPrice) {
    return swft.getPrice;
}

FRE_FUNCTION (getIsSwiftCool) {
    return swft.getIsSwiftCool;
}

FRE_FUNCTION (getHelloWorld) {
    return [swft getHelloWorldWithArgv:[aneHelper getNSArrayFromArgc:argc Argv:argv]];
}

void contextInitializer(void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet) {
    static FRENamedFunction extensionFunctions[] = {
        {(const uint8_t *) "getHelloWorld", NULL, &getHelloWorld},
        {(const uint8_t *) "getAge", NULL, &getAge},
        {(const uint8_t *) "getPrice", NULL, &getPrice},
        {(const uint8_t *) "getIsSwiftCool", NULL, &getIsSwiftCool}
    };

    *numFunctionsToSet = sizeof(extensionFunctions) / sizeof(FRENamedFunction);
    *functionsToSet = extensionFunctions;

    aneHelper = [[ANEHelperOC alloc] init];
    [aneHelper setCtx:ctx];
    swft = [[SwiftOSXANE alloc] init];
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
