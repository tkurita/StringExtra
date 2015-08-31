#import "StringExtra.h"

#ifndef   NSINTEGER_DEFINED
typedef int            NSInteger;
typedef unsigned int   NSUInteger;
#endif // NSINTEGER_DEFINED

@implementation NSMutableString (StringExtra)

- (unsigned int)replaceSubtextOfString:(NSString *)target withString:(NSString *)replacement options:(unsigned int)opts
{
	NSRange range = NSMakeRange(0, [self length]);
	return [self replaceOccurrencesOfString:target withString:replacement options:opts range:range];
}

- (unsigned int)replacePrefixOfString:(NSString *)target withString:(NSString *)replacement options:(unsigned int)opts
{
	NSRange range = NSMakeRange(0, [target length]);
	if (range.length) {
		if ([self length] >= range.length) {
			return [self replaceOccurrencesOfString:target withString:replacement options:opts range:range];
		} else {
			return 0;
		}
	} else {
		[self insertString:replacement atIndex:0];
	}
	return 1;
}

- (unsigned int)replaceSuffixOfString:(NSString *)target withString:(NSString *)replacement options:(unsigned int)opts
{
	NSRange range= NSMakeRange([self length] - [target length], [target length]);
	if (range.length) {
		return [self replaceOccurrencesOfString:target withString:replacement options:opts range:range];
	} else {
		[self appendString:replacement];
	}
	return 1;
}

@end


@implementation NSString (StringExtra)

- (NSMutableString *)normalizedString:(CFStringNormalizationForm) theForm
{
	NSMutableString *self_string = [self mutableCopy];
	CFStringNormalize((CFMutableStringRef) self_string,  theForm);
	return self_string;
}

- (BOOL)isEqualToNormalizedString:(NSString *)targetString
{
	NSMutableString *self_string = [self mutableCopy];
	NSMutableString *target_string = [targetString mutableCopy];
	CFStringNormalize((CFMutableStringRef) self_string,  kCFStringNormalizationFormKC);
	CFStringNormalize((CFMutableStringRef) target_string,  kCFStringNormalizationFormKC);
	return [self_string isEqualToString:target_string];
}

+ (NSString *)stringWithData:(NSData *)aData encodingCandidates:(NSArray *)encodings
{
	NSEnumerator *enumerator = [encodings objectEnumerator];
	NSNumber *encoding_packed;
	NSString *a_string = nil;
	while(encoding_packed = [enumerator nextObject]) {
		a_string = [[NSString alloc] initWithData:aData
									encoding:[encoding_packed unsignedIntValue]];
		if (a_string) break;
	}
	
	return a_string;	
}

- (BOOL)contain:(NSString *)containedText
{
	NSRange theRange = [self rangeOfString:containedText];
	return (theRange.length != 0);
}

- (BOOL)contain:(NSString *)target options:(unsigned int)opts
{
	NSRange range = [self rangeOfString:target options:opts range:NSMakeRange(0, [self length])];
	return (range.location != NSNotFound);
}

- (BOOL)hasPrefix:(NSString *)text options:(unsigned int)opts
{
	opts = opts|NSAnchoredSearch;
	NSRange range = NSMakeRange(0, [text length]);
	range = [self rangeOfString:text options:opts range:range];
	return (range.location != NSNotFound);
}

- (BOOL)hasSuffix:(NSString *)text options:(unsigned int)opts
{
	opts = opts|NSAnchoredSearch|NSBackwardsSearch;
	NSRange range = NSMakeRange([self length] - [text length], [text length]);
	range = [self rangeOfString:text options:opts range:range];
	return (range.location != NSNotFound);
}

- (NSMutableArray *)splitWithCharacterSet:(NSCharacterSet *)delimiters
{
	NSMutableArray * wordArray = [NSMutableArray array];
	NSScanner *scanner = [NSScanner scannerWithString:self];
	NSString *scannedText;
    while(![scanner isAtEnd]) {
        if([scanner scanUpToCharactersFromSet:delimiters intoString:&scannedText]) {
			[wordArray addObject:scannedText];
        }
        [scanner scanCharactersFromSet:delimiters intoString:nil];
    }
	return wordArray;
}

- (NSMutableArray *)paragraphs
{
    NSString* a_line;
    NSRange subrange;
    NSUInteger length = [self length];
    NSRange range = NSMakeRange(0, length);
	NSMutableArray *result = [NSMutableArray array];
    while(range.length > 0) {
        subrange = [self lineRangeForRange: NSMakeRange(range.location, 0)];
        a_line = [self substringWithRange:subrange];
		[result addObject:a_line];
        range.location = NSMaxRange(subrange);
        range.length -= subrange.length;
    }
	return result;
}

- (NSString *)hfsFileType
{
	return NSHFSTypeOfFile(self);
}

- (NSString *)stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding 
											leavings:(NSString *)charactersToLeaveUnescaped
											additionals:(NSString *)legalURLCharactersToBeEscaped 
{
	NSString *escaped_string = (NSString *)CFBridgingRelease(
                                        CFURLCreateStringByAddingPercentEscapes (NULL, (CFStringRef)self,
														  (CFStringRef)charactersToLeaveUnescaped,
														 (CFStringRef)legalURLCharactersToBeEscaped,
													(CFStringEncoding)encoding));
	return escaped_string;
}

+ (id)stringWithLocalizedFormat:(NSString *)format, ...
{
	NSString *localized_format = NSLocalizedString(format, @"");
	va_list args;
	va_start(args, format);
	NSString *result = [[NSString alloc] initWithFormat:localized_format arguments:args];
	va_end(args);
	return result;
}

@end
