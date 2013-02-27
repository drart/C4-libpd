//
//  C4PureData.h
//  C4-libpd
//
//  Created by Adam Tindale on 2013-02-20.
//  

#import <Foundation/Foundation.h>

#import "PdAudioController.h"
#import "PdDispatcher.h"
#import "PdFile.h"


@interface C4PureData : NSObject{
    PdAudioController * audioController;
    PdDispatcher * dispatcher;
    NSMutableArray *  patches;
}

-(id) init;
-(id) initWithPatch: (NSString *) patchName;

-(void) start;
-(void) stop;

// Patch Management
-(id) openPatch: (NSString *) patchName;
-(void) closePatch: (int) index;
-(void) closeThisPatch: (PdFile  * ) file;
-(void) closePatchFromFilename: (NSString *) fileName;
-(int) numberOfPatchesOpen;
-(PdFile *) returnPatch:(int) index;
-(void) printPatches;

// Messaging objects
-(void) sendBang: (NSString *) receiver;
-(void) sendBangToAPatch: (NSString *) receiver toPatch: (int) index;
-(void) sendFloat: (float) f toReceiver: (NSString *) r;
-(void) sendFloatToAPatch: (float) f toReceiver: (NSString *) r toPatch: (int) index;

// Send MIDI to PD
- (int)sendNoteOn:(int)channel pitch:(int)pitch velocity:(int)velocity;
- (int)sendControlChange:(int)channel controller:(int)controller value:(int)value;
- (int)sendProgramChange:(int)channel value:(int)value;
- (int)sendPitchBend:(int)channel value:(int)value;
- (int)sendAftertouch:(int)channel value:(int)value;
- (int)sendPolyAftertouch:(int)channel pitch:(int)pitch value:(int)value;
- (int)sendMidiByte:(int)port byte:(int)byte;
- (int)sendSysex:(int)port byte:(int)byte;
- (int)sendSysRealTime:(int)port byte:(int)byte;

@end
