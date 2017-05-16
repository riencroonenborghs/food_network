app = angular.module "foodNetwork.controllers", []

app.controller "appController", ["$scope", "NavbarFactory", ($scope, NavbarFactory) ->
  $scope.Navbar = new NavbarFactory
  $scope.Navbar.addTitle "FoodNetwork"

  $scope.search =
    query: ""  
]

app.controller "ProgramsController", ["$scope", "$location", "FoodNetwork",
($scope, $location, FoodNetwork) ->
  $scope.Navbar.reset()
  $scope.Navbar.addTitle "FoodNetwork"

  $scope.loading  = true
  $scope.programs = []

  FoodNetwork.programs().then (programs) -> 
    $scope.loading = false
    $scope.programs = programs

  $scope.episodes = (program) -> $location.path "/episodes/#{program.name}/#{program.url}"
]

app.controller "EpisodesController", ["$scope", "$location", "$routeParams", "FoodNetwork", "NavbarFactory",
($scope, $location, $routeParams, FoodNetwork, NavbarFactory) ->  
  name = $routeParams.name
  $scope.Navbar.reset()
  $scope.Navbar.addLink "/programs"
  $scope.Navbar.addTitle name

  url             = $routeParams.url
  $scope.loading  = true
  $scope.episodes = []

  FoodNetwork.episodes(url).then (episodes) ->
    $scope.loading = false
    $scope.episodes = episodes
]