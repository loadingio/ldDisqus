ldDisqus = (root) ->
  @root = if typeof(root) == \string => document.querySelector(root) else root
  @comments = []
  @

ldDisqus.prototype = Object.create(Object.prototype) <<< do
  init: ->
    @fetch!
  fetch: ->
    ajax({
      url: "/d/disqus"
      method: \GET
      data: "#{window.location.href}/"
    })
      .then ~> @comments = it
      .catch ->
  render: ->
    for comment in comments =>
  update: (comment) ->
    @comments.push comment
    @render!

post = ->
  ajax({
    url: '/d/disqus'
    method: \POST
    data: ...
  })
    .then -> # reorder / rendering
    .catch -> # show error
