app = angular.module "foodNetwork", [
  "ngAria", 
  "ngAnimate", 
  "ngMaterial", 
  "ngMdIcons",
  "foodNetwork.controllers",
  "foodNetwork.directives",
  "foodNetwork.services"
]

app.config ($mdThemingProvider) ->
  $mdThemingProvider.theme("default")
    .primaryPalette("red")
    .accentPalette("green")

app.constant "SERVER", "http://www.foodnetwork.com"
app.constant "EPISODES", "/videos/players/food-network-full-episodes.vc.html"