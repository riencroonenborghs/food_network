app = angular.module "foodNetwork.services", []

app.service "Channel", [ "$http", "$q", "SERVER", "EPISODES", "$parse", ($http, $q, SERVER, EPISODES, $parse) ->
  service:
    programs: ->
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
    episodes: (program) ->
      deferred = $q.defer()
      $http.get(SERVER+program.url).then (d) =>
        data = $(d.data).find("section#player-component")
        data2 = data.find("script")
        data3 = data2[0]
        scriptText = data3.text
        startIndex = scriptText.indexOf("{\"channels\":")
        scriptText = scriptText.substr(startIndex)
        # stopIndex = scriptText.indexOf("{\"extras\"") - 1
        stopIndex = scriptText.indexOf("}]}")+3
        scriptText = scriptText.substr(0, stopIndex)
        console.debug scriptText
        json = JSON.parse(scriptText)
        console.debug json
        
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
      console.debug "Channel.service.videos"
      console.debug "-- source"
      console.debug episode
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