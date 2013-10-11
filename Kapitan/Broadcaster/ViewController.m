#import "ViewController.h"

@interface ViewController () <CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic *transferCharacteristic;
@property (nonatomic, strong) NSMutableArray *centrals;
@property (atomic) NSInteger killStatus;
@property (weak, nonatomic) IBOutlet UIImageView *frontCharacterImage;
@property (weak, nonatomic) IBOutlet UILabel *killStatusLabel;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Init code here
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // init the peripheral manager and array for connected centrals
    
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    _centrals = [NSMutableArray array];
    _killStatus = 0;
    
    // Updated kill status
    [self updateKillStatus];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    // stop advertising when view will disappear
    
    [self.peripheralManager stopAdvertising];
    self.peripheralManager = nil;
    
    [super viewWillDisappear:animated];
}

-(void)updateKillStatus
{    
    [_killStatusLabel setText:[NSString stringWithFormat:@"Losers killed: %i", _killStatus]];
}


#pragma mark - CBPeripheral delegate methods

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    NSLog(@"PeripheralManager powered on.");
    
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString: CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:SERVICE_UUID] primary:YES];
    
    transferService.characteristics = @[self.transferCharacteristic];
    
    [self.peripheralManager addService:transferService];
    
    [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:SERVICE_UUID]], CBAdvertisementDataLocalNameKey : @"EstimoteBeacon" }];
    
    NSLog(@"PeripheralManager is broadcasting (%@).", SERVICE_UUID);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    [_centrals addObject:central];
    NSLog( @"New device connected" );
}

-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
        NSLog( @"Device disconnected: %i", _killStatus );
    [_centrals removeObject:central];
    // Increment killed monster indicator
    _killStatus++;
    // and updated it's status label
    [self updateKillStatus];
    
    NSLog( @"Device disconnected: %i", _killStatus );
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end