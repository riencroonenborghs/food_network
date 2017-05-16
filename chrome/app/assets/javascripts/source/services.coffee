app = angular.module "foodNetwork.services", []

app.service "FoodNetwork", [ "$http", "$q", "SERVER", "EPISODES", ($http, $q, SERVER, EPISODES) ->
  service =
    programs: ->
      deferred = $q.defer()
      $http.get(SERVER+EPISODES).then (d) ->
        programs = []
        for item in $(d.data).find(".m-MediaBlock--playlist")
          _item = $(item)
          image = _item.find("noscript").html().match(/src=\"(.*)\"/)[1]
          program = 
            name: _item.find(".m-MediaBlock__a-HeadlineText").html()
            url: _item.find(".m-MediaBlock__m-MediaWrap a").attr("href")
            image: image
          programs.push program if program.name
        deferred.resolve programs
      deferred.promise
    episodes: (url) ->
      deferred = $q.defer()
      $http.get(url).then (d) ->
        data = JSON.parse $(d.data).find(".m-VideoPlayer__a-ContainerInner #video-player script")[0].innerText
        episodes = for video in data.channels[0].videos
          episode =
            name: video.title
            image: SERVER + video.thumbnailUrl
            runtime: video.duration
            smilUrl: video.releaseUrl
        deferred.resolve episodes
      deferred.promise
    videos: (url) ->
      deferred = $q.defer()
      $http.get(url).then (d) ->
        videos  = []
        data    = d.data.replace(/video/g, 'replacedvideo')
        for _switch, index in $(data).find("switch")
          if index == 0
            for _video in $(_switch).find("replacedvideo")
              srcRe     = /src=\"(.+).mp4\"/
              widthRe   = /width=\"(\d+)\"/
              heightRe  = /height=\"(\d+)\"/
              video     = $(_video)[0].outerHTML
              src       = srcRe.exec(video)[1]
              width     = widthRe.exec(video)[1]
              height    = heightRe.exec(video)[1]
              videos.push {src: src, width: width, height: height}        
        deferred.resolve videos
      deferred.promise
  service
]