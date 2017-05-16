app = angular.module "foodNetwork", [
  "ngAria", 
  "ngAnimate", 
  "ngMaterial", 
  "ngMdIcons",
  "ngRoute"
  "foodNetwork.controllers",
  "foodNetwork.directives",
  "foodNetwork.services",
  "foodNetwork.factories"
]

app.config ($mdThemingProvider) ->
  $mdThemingProvider.theme("default")
    .primaryPalette("red")
    .accentPalette("green")

app.constant "SERVER", "http://www.foodnetwork.com"
app.constant "EPISODES", "/videos/players/food-network-full-episodes.vc.html"

app.config ($routeProvider, $locationProvider) ->
  $routeProvider
    .when "/programs",
      templateUrl: "app/views/programs.html"
      controller: "ProgramsController"
    .when "/episodes/:name/:url*",
      templateUrl: "app/views/episodes.html"
      controller: "EpisodesController"
    .otherwise "/programs",
      templateUrl: "app/views/programs.html"
      controller: "ProgramsController"
  $locationProvider.html5Mode true