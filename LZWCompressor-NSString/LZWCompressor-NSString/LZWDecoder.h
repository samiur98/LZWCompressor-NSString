// Header file for Decoder source file that decodes a compressed NSString Object and returns the original NSString object.

#import <Foundation/Foundation.h>
#import "LZWParser.h"
#import "LZWTrie.h"

NS_ASSUME_NONNULL_BEGIN
typedef unsigned char BYTE;
@interface LZWDecoder : NSObject
- (NSString *) decode: (NSString *) inputString; //Decodes NSString Object and returns original NSString object.
@end

NS_ASSUME_NONNULL_END
