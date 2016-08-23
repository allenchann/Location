#定位
最近碰到一个项目，涉及了定位。虽然以前也做过类似的项目，但是全部忘光了。现在重新拿起来，也顺便做个记录。
    现在地图类的应用很多都是使用百度地图提供的SDK,这里先就最简单的系统本身提供的说起。
    iOS本身提供了一个CoreLocation以及MapKit,一个提供了定位服务，一个提供了地图服务，下面先说CoreLocation
- CoreLocation
    - 导入库
        project->build Phase->输入CoreLocation,如图：
![Snip20160608_1.png](http://upload-images.jianshu.io/upload_images/1711673-7f4269d26eded403.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
        第一步就完成啦。
    - info.plist设置
        由于iOS8之后的某些设置，所以我们需要在APP中设置两个属性
```
NSLocationAlwaysUsageDescription
NSLocationWhenInUseUsageDescription
```
        如图：
![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1711673-37b7ad0adb0eb51b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
        基本配置就到这里啦，接下来回到程序
    - AppDelegate.m
        首先定义全局变量，同时签署CLLocationManagerDelegate协议，
        ```
    @interface AppDelegate ()<CLLocationManagerDelegate>
{
  CLLocationManager *_locationManager;
}
        ```
    didFinishLaunchingWithOptions中实现manager
        ```
      - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    _locationManager = [[CLLocationManager alloc] init];
    
    //设置代理
    
    _locationManager.delegate = self;
    
    //询问用户，获得权限。会有一个弹窗，询问用户是否允许app获取当前地理位置
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
    }
    else
        [_locationManager requestWhenInUseAuthorization];
    
    [_locationManager startUpdatingLocation];
    
    return YES;
}```
接下来在代理方法中就可以拿到我们的位置了

```
//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}
//定位完成
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    NSLog(@"%@",locations);
    NSLog(@"%f,%f",location.coordinate.longitude,location.coordinate.latitude);
    
    [manager stopUpdatingLocation];
}

```
有些人可能在模拟器中碰到这个问题
```
Domain=kCLErrorDomain Code=0 "(null)"
```
根据网上的很多方法改了也没用，后面发现在scheme中，Default Location中选择了none。然后任意选择了一个，就能成功更新位置了
![Snip20160608_5.png](http://upload-images.jianshu.io/upload_images/1711673-1b48eed527c656f3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

顺带一提,plist中有这一字段,可以向客户说明需要定位的原因.
```
Privacy - Location Usage Description
```

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1711673-31def5e36c7631bd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![Snip20160823_10.png](http://upload-images.jianshu.io/upload_images/1711673-40486330181dcc26.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
********************
#CLGeocoder(地理编码)
- 这个类主要为我们提供两个功能.
    - 1.从当前位置获取经纬度信息(地理编码)
    - 2.从已知经纬度获取当前位置信息(反地理编码)

#CLPlacemark(位置信息)
- 解析得到的位置信息,包含经纬度,省市区等详细信息

下面用代码来展示
```
//生成编码器
CLGeocoder *coder = [[CLGeocoder alloc]init];
//已知地址,想要获取当前地址经纬度(地理编码)
    NSString *str = @"中国广东省广州市天河区天园街道中山大道西";
//编码器开始编码,在返回的块中进行操作.
    [coder geocodeAddressString:str completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//判断是否编码出错
        if (error) {
            NSLog(@"%@",error);
        }
        else
        {
            //从解析的数据中获取到位置信息
            CLPlacemark *myPlace = [placemarks lastObject];
            //从位置信息中获取到想要解析的Location信息.
            CLLocation *location = myPlace.location;
            //编码器开始编码,在返回的块中进行操作.
            [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                if (!error)
                {
                    //同上
                    CLPlacemark *place = [placemarks lastObject];
                    NSLog(@"%@",place.addressDictionary);
                }
                else
                    NSLog(@"%@",error);
                
            }];
        }
    }];
```
以上就是地理编码与反地理编码的应用,很简单也很快捷.就不多赘述,后续更新地图的应用.
