#import <Cocoa/Cocoa.h>

@interface NSMutableString (StringExtra)

- (NSUInteger)replacePrefixOfString:(NSString *)target withString:(NSString *)replacement options:(unsigned int)opts;
- (NSUInteger)replaceSuffixOfString:(NSString *)target withString:(NSString *)replacement options:(unsigned int)opts;

@end

@interface NSString (StringExtra) 

- (NSMutableString *)normalizedString:(CFStringNormalizationForm) theForm;
- (BOOL)isEqualToNormalizedString:(NSString *)targetString;
- (BOOL)contain:(NSString *)containedText; 
- (BOOL)contain:(NSString *)target options:(unsigned int)opts;
- (BOOL)hasPrefix:(NSString *)text options:(unsigned int)opts;
- (BOOL)hasSuffix:(NSString *)text options:(unsigned int)opts;
+ (NSString *)stringWithData:(NSData *)aData encodingCandidates:(NSArray *)encodings;
- (NSMutableArray *)splitWithCharacterSet:(NSCharacterSet *)delimiters;
- (NSMutableArray *)paragraphs;
// get file type from POSX path
// mainly called from AppleScript
- (NSString *)hfsFileType;

- (NSString *)stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding 
											   leavings:(NSString *)charactersToLeaveUnescaped
											additionals:(NSString *)legalURLCharactersToBeEscaped;
+ (id)stringWithLocalizedFormat:(NSString *)format, ...;
@end
