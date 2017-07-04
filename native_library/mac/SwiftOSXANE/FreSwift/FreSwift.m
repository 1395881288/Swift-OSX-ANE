//
//  FreSwift.m
//
//  Created by Eoin Landy on 03/07/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "FreSwift_oc.h"
#import "FreSwift-Swift.h"
#import <FRESwift/FlashRuntimeExtensions.h>

FreSwift *swft;
#define FRE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

FRE_FUNCTION(initFreSwift) {
    return [swft initFreSwiftWithCtx:context argc:argc argv:argv];
}

void contextFinalizer(FREContext ctx) {
    return;
}

void contextInitializer(void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet,
                        const FRENamedFunction **functionsToSet) {
    
    static FRENamedFunction extensionFunctions[] =
    {
        { (const uint8_t*) "initFreSwift", NULL,&initFreSwift }
    };
    
    *numFunctionsToSet = sizeof( extensionFunctions ) / sizeof( FRENamedFunction );
    
    *functionsToSet = extensionFunctions;
    
}

void TRFRESExtInizer(void **extData, FREContextInitializer *ctxInitializer, FREContextFinalizer *ctxFinalizer) {
    *ctxInitializer = &contextInitializer;
    *ctxFinalizer = &contextFinalizer;
}

void TRFRESExtFinizer(void *extData) {
    FREContext nullCTX;
    nullCTX = 0;
    contextFinalizer(nullCTX);
    return;
}
