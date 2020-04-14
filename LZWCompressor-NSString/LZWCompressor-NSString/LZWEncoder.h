// Header file for Encoder source file that is responsible for encoding NSString Objects.
#import "LZWEncoder.h"
#import "LZWTrie.h"
#import "LZWWriter.h"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface LZWEncoder : NSObject

- (id) init;
- (NSString *) encode: (NSString *) inputString; //Method that encodes NSString Object.

@end

NS_ASSUME_NONNULL_END
