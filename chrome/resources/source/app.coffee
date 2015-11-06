app = angular.module "foodNetwork", [
  "ngAria", 
  "ngAnimate", 
  "ngMaterial", 
  "ngMdIcons",
]

app.config ($mdThemingProvider) ->
  $mdThemingProvider.theme("default")
    .primaryPalette("red")
    .accentPalette("green")

app.constant "SERVER", "http://www.foodnetwork.com"
app.constant "EPISODES", "/videos/players/food-network-full-episodes.vc.html"
app.service "Channel", [ "$http", "$q", "SERVER", "EPISODES", "$parse", ($http, $q, SERVER, EPISODES, $parse) ->
  service:
    episodesList: ->
      deferred = $q.defer()
      $http.get(SERVER+EPISODES).then (d) -> 
        links = $(d.data).find(".group-link")
        list  = for item in links
          item          = $(item)
          _link         = item
          _description  = item.find("h4[rel=ellipsis]").text()
          _name         = _description.replace("Full Episodes", "")
          _img          = item.find(".video-img-wrap img")
          { url: _link.attr('href'), name: _name, image: _img.attr("src"), description: _description }
        deferred.resolve list
      deferred.promise
    episodes: (episodeItem) ->
      deferred = $q.defer()
      $http.get(SERVER+episodeItem.url).then (d) => 
        data = $(d.data).find("section#player-component")
        data2 = data.find("script")
        data3 = data2[0]
        scriptText = data3.text
        startIndex = scriptText.indexOf("{\"channels\":")
        scriptText = scriptText.substr(startIndex)
        stopIndex = scriptText.indexOf(",{\"extras\"")
        scriptText = scriptText.substr(0, stopIndex)
        json = JSON.parse(scriptText)
        
        episodes = for item in json.channels[0].videos
          episode = 
            title: item.title
            description: item.description
            image: item.thumbnailUrl
            duration: item.length_hhmmss
            smil: item.releaseUrl
        deferred.resolve episodes
      deferred.promise    
    videos: (episode) ->
      deferred = $q.defer()
      $http.get(episode.smil).then (d) ->
        list = []
        data = d.data.replace(/video/g, 'replacedvideo');
        for _switch, index in $(data).find("switch")
          if index == 0
            for _video in $(_switch).find("replacedvideo")
              srcRe = /src=\"(.+).mp4\"/
              widthRe = /width=\"(\d+)\"/
              heightRe = /height=\"(\d+)\"/
              video = $(_video)[0].outerHTML
              src = srcRe.exec(video)[1]
              width = widthRe.exec(video)[1]
              height = heightRe.exec(video)[1]
              list.push {src: src, width: width, height: height}
        deferred.resolve list
      deferred.promise
]    

app.controller "appController", ["$scope", "Channel",
($scope, Channel) ->
  $scope.views        = {episodesList: true, episodes: false}
  $scope.episodesList = null
  $scope.episodesItem = null
  $scope.episodes     = null
  $scope.videos       = null
  $scope.loading      = true

  resetViews = ->
    $scope.views        = {episodesList: true, episodes: false}
  resetLists = ->
    $scope.episodesList = null
    $scope.episodesItem = null
    $scope.episodes     = null
    $scope.videos       = null

  # start with episodes list
  $scope.backToEpisodesList = -> backToEpisodesList()
  backToEpisodesList = ->
    $scope.loading = true
    resetViews()
    resetLists()
    Channel.service.episodesList().then (episodesList) -> 
      $scope.loading = false
      $scope.episodesList = episodesList
  backToEpisodesList()

  # episodes for episode item
  $scope.goToEpisodes = (episodeItem) ->
    $scope.loading = true
    $scope.views        = {episodesList: false, episodes: true}
    $scope.episodeItem  = episodeItem
    Channel.service.episodes(episodeItem).then (episodes) -> 
      $scope.loading = false
      $scope.episodes = episodes
]

app.directive "episodeVideos", [->
  restrict: "E"
  scope:
    episode: "="
  transclude: true
  templateUrl: "videos.html"
  controller: [ "$scope", "Channel", ($scope, Channel) ->
    $scope.videos = []
    Channel.service.videos($scope.episode).then (videos) ->
      $scope.videos = videos
  ]
]