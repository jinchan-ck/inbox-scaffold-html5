
define ["angular"], (angular, events) ->
  angular.module('baobab.service.namespace', [])
  .service('$namespaces', ['$inbox', '$auth', ($inbox, $auth) ->
    @_namespaces = []

    @current = () => @_namespaces[0]

    if $auth.token || !$auth.needToken()
      @promise = $inbox.namespaces().then (namespaces) =>
        ca = document.cookie.split(";")
        i = 0

        while i < ca.length
          c = ca[i]
          c = c.substring(1)  while c.charAt(0) is " "
          email = c.substring("uid=".length, c.length)  unless c.indexOf("uid") is -1
          i++
                             console.log(email)
        namespaces = namespaces.filter (namespace) ->
          console.log(namespace.emailAddress)
          "\"" + namespace.emailAddress + "\"" is email
                             console.log(namespaces)
        @_namespaces = namespaces
      ,
      (err) ->
        if (window.confirm("/n/ returned no namespaces. Click OK to be\logged out, or Cancel if you think this is a temporary issue."))
          $auth.clearToken()
    else
      @promise = Promise.reject("No auth token")

    @
  ])

  .factory('$namespaces-promise', ['$namespaces', ($n) -> $n.promise ])

