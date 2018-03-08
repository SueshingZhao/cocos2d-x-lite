#include "platform/CCCanvasRenderingContext2D.h"

#include "cocos/scripting/js-bindings/jswrapper/SeApi.h"

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#include <regex>

@interface CanvasRenderingContext2DImpl : NSObject {
    NSFont* _font;
    NSMutableDictionary* _tokenAttributesDict;
    NSString* _fontName;
    CGFloat _fontSize;
}

@property (nonatomic, strong) NSFont* font;
@property (nonatomic, strong) NSMutableDictionary* tokenAttributesDict;
@property (nonatomic, strong) NSString* fontName;

@end

@implementation CanvasRenderingContext2DImpl

@synthesize font = _font;
@synthesize tokenAttributesDict = _tokenAttributesDict;
@synthesize fontName = _fontName;

-(id) init {
    if ([super init]) {
        [self updateFontWithName:@"Arial" fontSize:30];
    }

    return self;
}

-(void) dealloc {
    self.font = nil;
    self.tokenAttributesDict = nil;
    self.fontName = nil;

    [super dealloc];
}

-(NSFont*) _createSystemFont {
    NSString* fntName = [[_fontName lastPathComponent] stringByDeletingPathExtension];
    NSFontTraitMask mask = NSUnboldFontMask | NSUnitalicFontMask;

    NSFont *font = [[NSFontManager sharedFontManager]
                    fontWithFamily:fntName
                    traits:mask
                    weight:0
                    size:_fontSize];

    if (font == nil) {
        font = [[NSFontManager sharedFontManager]
                fontWithFamily:@"Arial"
                traits: mask
                weight:0
                size:_fontSize];
    }
    return font;
}

-(void) updateFontWithName: (NSString*)fontName fontSize: (CGFloat)fontSize {
    self.fontName = fontName;
    _fontSize = fontSize;
    self.font = [self _createSystemFont];

    NSMutableParagraphStyle* paragraphStyle = [[[NSMutableParagraphStyle alloc] init] autorelease];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;

    // color
    NSColor* foregroundColor = [NSColor colorWithRed:1.0f
                                               green:1.0f
                                                blue:1.0f
                                               alpha:1.0f];

    // attribute
    self.tokenAttributesDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                foregroundColor, NSForegroundColorAttributeName,
                                                _font, NSFontAttributeName,
                                                paragraphStyle, NSParagraphStyleAttributeName, nil];
}

-(void) updateTextAlignment:(NSTextAlignment) alignment {

}

-(NSSize) measureText:(NSString*) text {

    NSAttributedString* stringWithAttributes = [[[NSAttributedString alloc] initWithString:text
                                                             attributes:_tokenAttributesDict] autorelease];

    NSSize textRect = NSZeroSize;
    textRect.width = CGFLOAT_MAX;
    textRect.height = CGFLOAT_MAX;

    NSSize dim;
#ifdef __MAC_10_11
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_10_11
    dim = [stringWithAttributes boundingRectWithSize:textRect options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin) context:nil].size;
#else
    dim = [stringWithAttributes boundingRectWithSize:textRect options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin)].size;
#endif
#else
    dim = [stringWithAttributes boundingRectWithSize:textRect options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin)].size;
#endif


    dim.width = ceilf(dim.width);
    dim.height = ceilf(dim.height);

    return dim;
}

-(void) fillText:(NSString*) text x:(NSInteger) x y:(NSInteger) y width:(NSInteger) width height:(NSInteger) height {
//    CGFloat xPadding = 0;
//    CGFloat yPadding = 0;
//
//    NSInteger POTWide = width;
//    NSInteger POTHigh = height;
//    NSRect textRect = NSMakeRect(0, 0,
//                                 width, height);
//
//
//    [[NSGraphicsContext currentContext] setShouldAntialias:NO];
//
//    NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize(POTWide, POTHigh)];
//    [image lockFocus];
//    // patch for mac retina display and lableTTF
//    [[NSAffineTransform transform] set];
//    NSAttributedString *stringWithAttributes =[[[NSAttributedString alloc] initWithString:text
//                                                                               attributes:_tokenAttributesDict] autorelease];
//    [stringWithAttributes drawInRect:textRect];
//    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect (0.0f, 0.0f, POTWide, POTHigh)];
//    [image unlockFocus];
//
//    auto data = (unsigned char*) [bitmap bitmapData];  //Use the same buffer to improve the performance.
//
//    NSUInteger textureSize = POTWide * POTHigh * 4;
//    auto dataNew = (unsigned char*)malloc(sizeof(unsigned char) * textureSize);
//    if (dataNew) {
//        memcpy(dataNew, data, textureSize);
//        // output params
//        info->width = static_cast<int>(POTWide);
//        info->height = static_cast<int>(POTHigh);
//        info->data = dataNew;
//        info->isPremultipliedAlpha = true;
//        ret = true;
//    }
//    [bitmap release];
//    [image release];
}

@end

NS_CC_BEGIN

CanvasGradient::CanvasGradient()
{
    SE_LOGD("CanvasGradient constructor: %p\n", this);
}

CanvasGradient::~CanvasGradient()
{
    SE_LOGD("CanvasGradient destructor: %p\n", this);
}

void CanvasGradient::addColorStop(float offset, const std::string& color)
{
    SE_LOGD("CanvasGradient::addColorStop: %p\n", this);
}

// CanvasRenderingContext2D

CanvasRenderingContext2D::CanvasRenderingContext2D(float width, float height)
: __width(width)
, __height(height)
{
    SE_LOGD("CanvasGradient constructor: %p, width: %f, height: %f\n", this, width, height);
    _impl = [[CanvasRenderingContext2DImpl alloc] init];
}

CanvasRenderingContext2D::~CanvasRenderingContext2D()
{
    SE_LOGD("CanvasGradient destructor: %p\n", this);
}

void CanvasRenderingContext2D::recreateBuffer()
{
    _isBufferSizeDirty = false;
}

void CanvasRenderingContext2D::clearRect(float x, float y, float width, float height)
{
    SE_LOGD("CanvasGradient::clearRect: %p, %f, %f, %f, %f\n", this, x, y, width, height);
}

Data CanvasRenderingContext2D::getImageData(float sx, float sy, float sw, float sh)
{
    SE_LOGD("CanvasGradient::getImageData: %p, %f, %f, %f, %f\n", this, sx, sy, sw, sh);
    return Data();
}

void CanvasRenderingContext2D::fillText(const std::string& text, float x, float y, float maxWidth)
{
    SE_LOGD("CanvasRenderingContext2D::fillText: %s, %f, %f, %f\n", text.c_str(), x, y, maxWidth);
    if (_isBufferSizeDirty)
        recreateBuffer();
}

void CanvasRenderingContext2D::strokeText(const std::string& text, float x, float y, float maxWidth)
{
    SE_LOGD("CanvasRenderingContext2D::strokeText: %s, %f, %f, %f\n", text.c_str(), x, y, maxWidth);
    if (_isBufferSizeDirty)
        recreateBuffer();
}

cocos2d::Size CanvasRenderingContext2D::measureText(const std::string& text)
{
    SE_LOGD("CanvasRenderingContext2D::measureText: %s\n", text.c_str());
    CGSize size = [_impl measureText: [NSString stringWithUTF8String:text.c_str()]];
    return cocos2d::Size(size.width, size.height);
}

CanvasGradient* CanvasRenderingContext2D::createLinearGradient(float x0, float y0, float x1, float y1)
{
    return nullptr;
}

void CanvasRenderingContext2D::save()
{

}

void CanvasRenderingContext2D::beginPath()
{

}

void CanvasRenderingContext2D::closePath()
{

}

void CanvasRenderingContext2D::moveTo(float x, float y)
{

}

void CanvasRenderingContext2D::lineTo(float x, float y)
{

}

void CanvasRenderingContext2D::stroke()
{

}

void CanvasRenderingContext2D::restore()
{

}

void CanvasRenderingContext2D::set__width(float width)
{
    SE_LOGD("CanvasRenderingContext2D::set__width: %f\n", width);
    __width = width;
    _isBufferSizeDirty = true;
}

void CanvasRenderingContext2D::set__height(float height)
{
    SE_LOGD("CanvasRenderingContext2D::set__height: %f\n", height);
    __height = height;
    _isBufferSizeDirty = true;
}

void CanvasRenderingContext2D::set_lineWidth(float lineWidth)
{

}

void CanvasRenderingContext2D::set_lineJoin(const std::string& lineJoin)
{

}

void CanvasRenderingContext2D::set_font(const std::string& font)
{
    if (_font != font)
    {
        _font = font;

        std::string fontName = "Arial";
        std::string fontSizeStr = "30";

        std::regex re("(\\d+)px\\s+(\\w+)");
        std::match_results<std::string::const_iterator> results;
        if (std::regex_search(_font.cbegin(), _font.cend(), results, re))
        {
            fontName = results[2].str();
            fontSizeStr = results[1].str();
        }

        CGFloat fontSize = atof(fontSizeStr.c_str());
        [_impl updateFontWithName:[NSString stringWithUTF8String:fontName.c_str()] fontSize:fontSize];
    }
}

void CanvasRenderingContext2D::set_textAlign(const std::string& textAlign)
{
    SE_LOGD("CanvasRenderingContext2D::set_textAlign: %s\n", textAlign.c_str());
}

void CanvasRenderingContext2D::set_textBaseline(const std::string& textBaseline)
{
    SE_LOGD("CanvasRenderingContext2D::set_textBaseline: %s\n", textBaseline.c_str());
}

void CanvasRenderingContext2D::set_fillStyle(const std::string& fillStyle)
{

}

void CanvasRenderingContext2D::set_strokeStyle(const std::string& strokeStyle)
{

}

void CanvasRenderingContext2D::set_globalCompositeOperation(const std::string& globalCompositeOperation)
{
    
}

NS_CC_END
