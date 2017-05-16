app = angular.module "foodNetwork.directives", []

app.directive "navbar", [->
  restrict: "E"
  scope:
    model: "="
  templateUrl: "app/views/navbar.html"
  controller: [ "$scope", "$location", ($scope, $location) ->
    $scope.go = (url) -> $location.path url
  ]
]

app.directive "videos", [->
  restrict: "E"
  scope:
    episode: "="
  transclude: true
  templateUrl: "app/views/videos.html"
  controller: [ "$scope", "FoodNetwork", ($scope, FoodNetwork) ->
    $scope.videos   = []
    $scope.loading  = true
    FoodNetwork.videos($scope.episode.smilUrl).then (data) ->
      $scope.loading  = false
      $scope.videos   = data
  ]
]