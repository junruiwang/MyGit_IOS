//
//  GLKSkyBoxViewController.m
//  JinJiangHotel
//
//  Created by Rong Hao on 13-8-19.
//  Copyright (c) 2013年 jinjiang. All rights reserved.
//

#import "GLKSkyBoxViewController.h"
#import "AGLKContext.h"

@interface GLKSkyBoxViewController()

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) GLKSkyboxEffect *skyboxEffect;
@property (strong, nonatomic) GLKTextureInfo *textureInfo;
@property (assign, nonatomic, readwrite) GLKVector3 eyePosition;
@property (assign, nonatomic) GLKVector3 lookAtPosition;
@property (assign, nonatomic) GLKVector3 upVector;
@property (assign, nonatomic) float angle;
@property (assign, nonatomic) float neck;
@property (nonatomic) CGFloat angleModify;
@property (nonatomic) CGFloat neckModify;

@end

@implementation GLKSkyBoxViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    view.context = [[AGLKContext alloc]
                    initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(
                                                         0.9f, // Red
                                                         0.9f, // Green
                                                         0.9f, // Blue
                                                         1.0f);// Alpha
    self.baseEffect.light0.diffuseColor = GLKVector4Make(
                                                         1.0f, // Red
                                                         1.0f, // Green
                                                         1.0f, // Blue
                                                         1.0f);// Alpha
    
    self.eyePosition = GLKVector3Make(0.0, 3.0, 3.0);
    self.lookAtPosition = GLKVector3Make(0.0, 0.0, 0.0);
    self.upVector = GLKVector3Make(0.0, 1.0, 0.0);
    
    NSData *pngData = UIImagePNGRepresentation([UIImage imageNamed:@"newnewnew2_24.png"]);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"360.png"]; //Add the file name
    
    [pngData writeToFile:filePath atomically:YES];
    
//    NSString *path = [[NSBundle bundleForClass:[self class]]
//                      pathForResource:fileName ofType:@"png"];
    NSAssert(nil != filePath, @"Path to skybox image not found");
    NSError *error = nil;
    self.textureInfo = [GLKTextureLoader
                        cubeMapWithContentsOfFile:filePath
                        options:nil
                        error:&error];
    
    self.skyboxEffect = [[GLKSkyboxEffect alloc] init];
    self.skyboxEffect.textureCubeMap.name = self.textureInfo.name;
    self.skyboxEffect.textureCubeMap.target =
    self.textureInfo.target;
    self.skyboxEffect.xSize = 12.0f;
    self.skyboxEffect.ySize = 12.0f;
    self.skyboxEffect.zSize = 12.0f;
    
    [((AGLKContext *)view.context) enable:GL_CULL_FACE];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.baseEffect = nil;
    self.skyboxEffect = nil;
    self.textureInfo = nil;
}


- (void)preparePointOfViewWithAspectRatio:(GLfloat)aspectRatio
{
    self.baseEffect.transform.projectionMatrix =
    GLKMatrix4MakePerspective(
                              GLKMathDegreesToRadians(85.0f),
                              aspectRatio,
                              0.1f, 
                              20.0f); 
    
    self.baseEffect.transform.modelviewMatrix =
    GLKMatrix4MakeLookAt(
                         self.eyePosition.x,     
                         self.eyePosition.y,
                         self.eyePosition.z,
                         self.lookAtPosition.x,  
                         self.lookAtPosition.y,
                         self.lookAtPosition.z,
                         self.upVector.x,         
                         self.upVector.y,
                         self.upVector.z);
    self.neck += self.neckModify;
    self.angle += self.angleModify;
    self.eyePosition = GLKVector3Make(
                                      3.0f * sinf(_angle),
                                      3.0f,
                                      3.0f * cosf(_angle));
    
    self.lookAtPosition = GLKVector3Make(
                                         0.0,
                                         1.5 + 3.0f * sinf(0.3 * self.neck),
                                         0.0);
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    const GLfloat  aspectRatio =
    (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;
    
    [(AGLKContext *)view.context clear:
     GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    
    [self preparePointOfViewWithAspectRatio:aspectRatio];
    
    self.baseEffect.light0.position = GLKVector4Make(
                                                     0.4f,
                                                     0.4f, 
                                                     -0.3f,  
                                                     0.0f);
    
    self.skyboxEffect.center = self.eyePosition;
    self.skyboxEffect.transform.projectionMatrix = 
    self.baseEffect.transform.projectionMatrix;
    self.skyboxEffect.transform.modelviewMatrix = 
    self.baseEffect.transform.modelviewMatrix;
    [self.skyboxEffect prepareToDraw];
    [self.skyboxEffect draw];
    glBindVertexArrayOES(0);
    
    
#ifdef DEBUG
    {  // Report any errors 
        GLenum error = glGetError();
        if(GL_NO_ERROR != error)
        {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
}

- (IBAction)toLeftPressed:(id)sender {
    self.angleModify = 0;
}
- (IBAction)toRightPressed:(id)sender {
    self.angleModify = 0;
}

- (IBAction)rightDown:(id)sender {
    self.angleModify = -0.01;
}
- (IBAction)leftDown:(id)sender {
    self.angleModify = 0.01;
}
- (IBAction)toUpPressed:(id)sender {
    self.neckModify = 0;
}
- (IBAction)toDownPressed:(id)sender {
    self.neckModify = 0;
}
- (IBAction)upDown:(id)sender {
    self.neckModify = 0.01;
}
- (IBAction)downDown:(id)sender {
    self.neckModify = -0.01;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != 
            UIInterfaceOrientationPortraitUpsideDown);
}

@end
