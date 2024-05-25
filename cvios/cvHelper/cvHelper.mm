#import "cvHelper.h"
#import <opencv2/opencv.hpp>

NSString *MatToBase64(const cv::Mat &mat) {
    std::vector<uchar> buf;
    cv::imencode(".png", mat, buf);
    auto base64_str = [[NSData dataWithBytes:buf.data() length:buf.size()] base64EncodedStringWithOptions:0];
    return base64_str;
}

// Helper function to convert Base64 to cv::Mat
cv::Mat Base64ToMat(NSString *base64_str) {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64_str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    std::vector<uchar> buf((uchar *)data.bytes, (uchar *)data.bytes + data.length);
    cv::Mat mat = cv::imdecode(buf, cv::IMREAD_UNCHANGED);
    return mat;
}
@implementation cvHelper

+ (NSString *)processImage:(NSString *)imageBase64 {
    // Convert Base64 string to cv::Mat
    cv::Mat mat = Base64ToMat(imageBase64);
    
    // Process the image using OpenCV (for example, convert to grayscale)
    cv::Mat grayMat;
    cv::cvtColor(mat, grayMat, cv::COLOR_BGR2GRAY);
    
    // Convert processed cv::Mat to Base64 string
    NSString *processedImageBase64 = MatToBase64(grayMat);
    
    return processedImageBase64;
}
@end
