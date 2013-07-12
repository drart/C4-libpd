//
//  C4PD.h
//  C4-libpd
//
//  Created by Adam Tindale on 2013-04-04.
//

#import "C4Object.h"
#import "TheAmazingAudioEngine.h"

@interface C4PD : C4Object <AEAudioPlayable>

@property (nonatomic, strong) AEAudioController *controller;
//@property (nonatomic, strong) AEBlockChannel * channel;

-(id) init;
-(id) initWithPatch: (NSString *) patchName;

// Turn DSP on and off
-(void) start;
-(void) stop;

// Patch Management
-(int) openPatch: (NSString *) patchName;
-(int) openPatch: (NSString *) patchName inDirectory:(NSString *)pathName;
-(void) closePatch: (int) index;
-(int) numberOfPatchesOpen;

//-(void) closePatchFromFilename: (NSString *) fileName;
//-(void) printPatches;
//-(NSArray *) patchNames;

// Messaging objects
-(void) sendBang:(NSString *)receive;
-(void) sendBangToAPatch:(NSString *)receive toPatch:(int)index;
-(void) sendFloat: (float)f toReceive:(NSString *)receive;
-(void) sendFloatToAPatch:(float)f toReceive:(NSString *)receive toPatch:(int)index;

+(void)sendMessage:(NSString *)message withArguments:(NSArray *)list toReceive:(NSString *)receive;

// Send MIDI to PD
/*- (int)sendNoteOn:(int)channel pitch:(int)pitch velocity:(int)velocity;
- (int)sendControlChange:(int)channel controller:(int)controller value:(int)value;
- (int)sendProgramChange:(int)channel value:(int)value;
- (int)sendPitchBend:(int)channel value:(int)value;
- (int)sendAftertouch:(int)channel value:(int)value;
- (int)sendPolyAftertouch:(int)channel pitch:(int)pitch value:(int)value;
- (int)sendMidiByte:(int)port byte:(int)byte;
- (int)sendSysex:(int)port byte:(int)byte;
- (int)sendSysRealTime:(int)port byte:(int)byte;
*/

// Amazing Audio Engine methods
static void audioCallback(id THIS, AEAudioController *audioController, void *source, const AudioTimeStamp *time, UInt32 frames, AudioBufferList *audio);
- (AEAudioControllerAudioCallback)receiverCallback;


@end
