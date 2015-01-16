
define ["angular"], (angular, events) ->
  angular.module('baobab.service.namespace', [])
  .service('$namespaces', ['$inbox', '$auth', ($inbox, $auth) ->
    @_namespaces = []

    @current = () => @_namespaces[0]

    if $auth.token || !$auth.needToken()
      ca = document.cookie.split(";")
      i = 0
      while i < ca.length
        c = ca[i]
        c = c.substring(1)  while c.charAt(0) is " "
        namespace_id = c.substring("namespace_id=".length, c.length)  unless c.indexOf("namespace_id") is -1
        i++
      console.log(namespace_id)
      @promise = $inbox.namespace(namespace_id).then (namespace) =>
        @_namespaces = [namespace]

#      @promise = $inbox.namespaces().then (namespaces) =>
#
#        namespaces = namespaces.filter (namespace) ->
#          console.log(namespace.emailAddress)
#          "\"" + namespace.emailAddress + "\"" is namespace_id
#        @_namespaces = namespaces
      ,
      (err) ->
        if (window.confirm("/n/ returned no namespaces. Click OK to be\logged out, or Cancel if you think this is a temporary issue."))
          $auth.clearToken()
    else
      @promise = Promise.reject("No auth token")

    @
  ])

  .factory('$namespaces-promise', ['$namespaces', ($n) -> $n.promise ])

