app = angular.module "foodNetwork.controllers", [
  "foodNetwork.services"
]

app.controller "appController", ["$scope", "Channel",
($scope, Channel) ->
  $scope.views    = {programs: true, episodes: false}
  $scope.programs = null
  $scope.program  = null
  $scope.episodes = null
  $scope.videos   = null
  $scope.loading  = true

  resetViews = ->
    $scope.views = {programs: true, episodes: false}
  resetLists = ->
    $scope.programs = null
    $scope.program  = null
    $scope.episodes = null
    $scope.videos   = null

  # start with programs
  $scope.backToPrograms = -> backToPrograms()
  backToPrograms = ->
    $scope.loading = true
    resetViews()
    resetLists()
    Channel.service.programs().then (programs) -> 
      $scope.loading = false
      $scope.programs = programs
  backToPrograms()

  # episodes for program
  $scope.goToProgram = (program) ->
    $scope.loading  = true
    $scope.views    = {programs: false, episodes: true}
    $scope.program  = program
    Channel.service.episodes(program).then (episodes) -> 
      $scope.loading = false
      $scope.episodes = episodes
]