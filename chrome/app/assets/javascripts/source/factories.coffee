app = angular.module "foodNetwork.factories", []

app.factory "NavbarFactory", [ "$location", ($location) ->
  class Model
    constructor: -> @list = []
    addTitle: (title) -> @list.push type: "title", title: title
    addLink: (url, label) -> @list.push type: "link", url: url, label: label, go: => $location.path url
    reset: -> @list = []
]