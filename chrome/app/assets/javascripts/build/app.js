// Generated by CoffeeScript 1.9.3
(function() {
  var app;

  app = angular.module("foodNetwork", ["ngAria", "ngAnimate", "ngMaterial", "ngMdIcons", "foodNetwork.controllers", "foodNetwork.directives", "foodNetwork.services"]);

  app.config(function($mdThemingProvider) {
    return $mdThemingProvider.theme("default").primaryPalette("red").accentPalette("green");
  });

  app.constant("SERVER", "http://www.foodnetwork.com");

  app.constant("EPISODES", "/videos/players/food-network-full-episodes.vc.html");

}).call(this);