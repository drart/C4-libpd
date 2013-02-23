//
//  C4PureData.h
//  C4-libpd
//
//  Created by Adam Tindale on 2013-02-20.
//  Copyright (c) 2013 Adam Tindale. All rights reserved.
//  

#import <Foundation/Foundation.h>

#import "PdAudioController.h"
#import "PdDispatcher.h"
#import "PdFile.h"


@interface C4PureData : NSObject{
    PdDispatcher * dispatcher;
    NSMutableArray *  patches;
}

-(id) init;
-(id) initWithPatch: (NSString *) patchName;

-(void) stop;
-(void) start;

// Patch Management
-(void) openPatch: (NSString *) patchName;
-(void) closePatch: (int) index;  // or can i call from filename?
-(int) patchesOpen;
-(PdFile *) returnPatch:(int) index;

// Messaging objects
-(void) sendBang: (NSString *) receiver;
-(void) sendBangToAPatch: (NSString *) receiver toPatch: (int) index;
-(void) sendFloat: (float) f toReceiver: (NSString *) r;
-(void) sendFloatToAPatch: (float) f toReceiver: (NSString *) r toPatch: (int) index;

@property (strong, nonatomic, readonly) PdAudioController * audioController;
//@property (strong, nonatomic, readonly) PdDispatcher * dispatcher;
@end
