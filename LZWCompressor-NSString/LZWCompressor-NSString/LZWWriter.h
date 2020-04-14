// Header file for Writer source file that returns a byte when appropriate.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef struct Buffer{
    //Buffer struct for storing bits.
    unsigned char container;
    unsigned char containerSize;
} Buffer;
@interface LZWWriter : NSObject
@property(nonatomic, readwrite) Buffer buf;

- (id) init;
- (unsigned char) writeValue: (unsigned short) value withSize: (unsigned char) size; //Returns a Byte when appropriate.
- (unsigned char) clearGutter; //Returns left-over bits and/or Final Byte.
@end

NS_ASSUME_NONNULL_END
