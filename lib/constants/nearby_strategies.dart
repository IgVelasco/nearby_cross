enum NearbyStrategies { cluster, star, pointToPoint }

extension NearbyStrategiesString on NearbyStrategies {
  String toPresentationString() {
    switch (this) {
      case NearbyStrategies.cluster:
        return "Cluster";
      case NearbyStrategies.star:
        return "Star";
      case NearbyStrategies.pointToPoint:
        return "Point to Point";
    }
  }

  String toStrategyString() {
    switch (this) {
      case NearbyStrategies.cluster:
        return "P2P_CLUSTER";
      case NearbyStrategies.star:
        return "P2P_STAR";
      case NearbyStrategies.pointToPoint:
        return "P2P_POINT_TO_POINT";
    }
  }
}
