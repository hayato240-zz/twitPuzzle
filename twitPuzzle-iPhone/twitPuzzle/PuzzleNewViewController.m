//
//  PuzzleNewViewController.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/22.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import "PuzzleNewViewController.h"
#import "Puzzle.h"

#define DVICOUNT 3
#define PUZZLENUM 9

@interface PuzzleNewViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tweetField;
- (IBAction)tweetBtn:(id)sender;
- (IBAction)touchImageBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *originImage;
@property (strong, nonatomic) NSMutableArray *views;
@property (weak, nonatomic) IBOutlet UIImageView *divImage;

@property (weak, nonatomic) IBOutlet UIImageView *puzzleImage;


@end

@implementation PuzzleNewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)tweetBtn:(id)sender {
//    NSData *imgData = UIImageJPEGRepresentation(_originImage.image, 1.0f);
    
    _puzzle.tweet = _tweetField.text;
//    _puzzle.image = imgData;
    [self post];
 //  [_puzzle save];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchImageBtn:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (UIImage*)resizedImage:(UIImage *)img size:(CGSize)size
{
    CGFloat widthRatio  = size.width  / img.size.width;
    CGFloat heightRatio = size.height / img.size.height;
    
    CGFloat ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio;
    CGSize resizedSize = CGSizeMake(img.size.width*ratio, img.size.height*ratio);
    
    UIGraphicsBeginImageContext(resizedSize);
    
    [img drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _originImage.image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];

    //元画像の分割＝パズル化
//    NSMutableArray *resultImages = [self divImage:_originImage.image];
    NSMutableArray *resultImages = [Puzzle divImage:_originImage.image];
    _puzzleImage.image = [resultImages objectAtIndex:0];
   
    //パズル画像の乱数を作成
    int arrayNum[9]={0,1,2,3,4,5,6,7,8};
    int *resultRund = [self rundumImageNum:arrayNum];
    
    CGFloat blockWidth = _puzzleImage.image.size.width / 3.0;
    CGFloat blockHeight = _puzzleImage.image.size.height / 3.0;
    int num=0;
    UIGraphicsBeginImageContext(CGSizeMake(_puzzleImage.image.size.width, _puzzleImage.image.size.height));
    for (int heightNum=0; heightNum<DVICOUNT; heightNum++) {
       for (int widthNum=0; widthNum<DVICOUNT; widthNum++) {
           UIImage *tmpImage = [self resizedImage:[resultImages objectAtIndex:resultRund[num]] size:CGSizeMake(_puzzleImage.image.size.width / 3.0, _puzzleImage.image.size.height / 3.0)];
           [tmpImage drawAtPoint:CGPointMake(widthNum*blockWidth, heightNum*blockHeight)];
           num++;
        }
    }
    UIImage *divImages = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _puzzleImage.image = divImages;

    // カメラUIを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(int *)rundumImageNum:(int *)num{
    int tmp;
    
    for (int i = 0; i < 4; i++) {
        int j = rand()%9;
        tmp = num[i];
        num[i] = num[j];
        num[j] = tmp;
    }

    NSMutableString *rundumStr = [NSMutableString string];
    for(int i=0; i<9; i++){
        [rundumStr appendString:[NSString stringWithFormat:@"%d,",num[i]+1]];
    }
    for(int i=0; i<9; i++){
//        NSLog(@"runstr::::::::%@",rundumStr);
        
    }
    _puzzle.correct_order = rundumStr;
    
    return num;
}

-(void)post
{
    UIImage *upload_image = _puzzleImage.image;
    NSMutableData *postData = [NSMutableData data];
    NSString *bound = @"--123456789012345678901234567890";
    
    
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding]]; // データ単位の開始を表すバウンド
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", @"puzzle[tweet]"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[_puzzle.tweet dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    
//    NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaa::::%@",_puzzle.correct_order );
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding]]; // データ単位の開始を表すバウンド
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", @"puzzle[correct_order]"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[_puzzle.correct_order dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    


    // 画像データの追加 -- ここから --
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"puzzle[image]", @"test"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n", @"image/jpeg"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *imageData = UIImageJPEGRepresentation(upload_image, 1.0f);
    [postData appendData:imageData];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // 画像データの追加 -- ここまで --

    // データの終端を表すバウンド（※開始バウンドと異なり、末尾が２つのハイフンになっていることに注意）
    [postData appendData:[[NSString stringWithFormat:@"--%@--\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    NSURL *nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/puzzles.json",SERVER_URL]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:nsUrl];
    NSData *body = postData;
    

    [req setHTTPMethod:@"POST"];
    [req setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [req setTimeoutInterval:10.0];
    [req setHTTPBody:body];
    [req setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    [req setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", bound] forHTTPHeaderField:@"Content-Type"];
    
    
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
//    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];

    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *dataResults = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    if (!dataResults || response.statusCode != 200) {
        NSLog(@"NSURLConnection error:%@ status:%d", error, response.statusCode);
    }
    

}


@end
