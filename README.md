# Nearby Cross

A flutter plugin that uses Google's Nearby Connections to connect devices across multiple operative systems

## Getting Started

Add the dependency: 
```zsh
flutter pub get nearby_cross
```

And follow the steps for working in iOS

1. You need to request the access to protected resources in the following [link](https://developers.google.com/nearby/connections/swift/get-started#request_access_to_protected_resources)
2. Run pod install inside the ios folder
3. Open XCode and install nearby using SPM
4. Done!


## Models

### Connector
- functions that are shared between discoverer and advertiser
- Main model managing advertiser and discoverer
- Multiple callbacks define for when an action like a connection or data is being received


```
```

### Advertiser
- The advertiser has the functions to `advertise` and `stopAdvertising` and all the Connector functions
- To advertise you need to indicate the service id for example `com.example.nearbyCrossExample` used in the example app
- Its basically the one starting the network
- You can choose between different strategies:
    - Star
    - Cluster
    - Point To Point

```dart
final advertiser = Advertiser()
/* Future<void> advertise(
  String serviceId, {
  bool manualAcceptConnections = false,
  NearbyStrategies strategy = NearbyStrategies.star,
})
*/
advertiser.startAdvertising('com.example.nearbyCrossExample', false, NearbyStrategies.star)
//
// ... send or receive connections
//
advertiser.stopAdvertising()
```

### Discoverer
- The discoverer that connects to the advertiser, its the one connecting to the advertiser


### ConnectionManager
- all callbacks generated for in between actions, device disconnected, new data received etc



## Example
In the example folder there's a chat implemented utilizing the plugin which you can share messages and stop and start the connection choosing which strategy you want


## More links
- [Nearby Connections GH](https://github.com/google/nearby/tree/main/connections)
- [Nearby Connections Documentation](https://developers.google.com/nearby/connections/overview)

