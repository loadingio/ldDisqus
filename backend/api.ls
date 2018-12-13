/*
table disqus
  key serial primary key,
  url text,
  slug text,
  ispublic boolean,
  moderate boolean default true

table comment
  key serial primary key,
  disqus int references disqus(key),
  owner int references users(key),
  createdtime timestamp default now(),
  modifiedtime timestamp default now(),
  reply int references comment(key),
  content text,
  state text,
  deleted boolean
*/
# state   ANY('{published, moderate, spam}')

api.post \/disqus/, engine.multi.parser, (req, res) ->
  if !req.user or !req.user.key => return aux.r400 res
  owner = req.user.key
  # parsing content, including images ...
  io.query("insert into comment (owner,createdtime,reply,content) values ($1, $2, $3, $4)", [
    owner, Date.now!, reply, content
  ]).then -> res.send!
    .catch aux.error-handler res

api.delete \/disqus/:key, authorized (req, res) ->
  if !req.params.id or isNaN(req.params.id) => return aux.r400 res
  io.query "select key from comment where key = $1", [key]
    .then -> res.send!
    .catch aux.error-handler res

api.get \/disqus/:key, (req, res) ->
  # privacy control
  io.query "select * from disqus where slug = $1", [slug]
    .then (r={}) ->
      if !(disqus = r.[]rows.0) => return [] #?
      io.query "select * from comment where disqus = $1 order by createdtimea", [disqus.key]
    .then (r={}) -> res.send(r.rows or [])
    .catch aux.error-handler res
