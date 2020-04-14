// Header file for the Parser source file that parses encoded string during the decoding process.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef struct Container{
    //Container Struct for storing bits.
    unsigned short value;
    unsigned char containerSize;
} Container;

@interface LZWParser : NSObject

@property(nonatomic, readwrite) Container container;

- (id) init;
- (BOOL) isReady: (unsigned char) size; //Returns true if container has enough bits, specified by the size.
- (unsigned short) getValue: (unsigned char) size; //Returns the oldest n number of bits in the container, where n is specified by the size argument.
- (void) append: (unsigned char) value; //Adds 8 bits to the container and appends the containerSize accordingly.
@end

NS_ASSUME_NONNULL_END
