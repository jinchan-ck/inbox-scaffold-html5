define ['angular'], (angular) ->
  angular.module("baobab.controller.app", [])
    .controller('AppCtrl', [
        '$scope',
        '$namespaces',
        '$inbox',
        '$auth',
        '$location',
        '$cookieStore',
        '$sce',
        '$http',
    ($scope, $namespaces, $inbox, $auth, $location, $cookieStore, $sce, $http) ->
      window.AppCtrl = @
      self = @
      @inboxAuthURL = $sce.trustAsResourceUrl('')

      $scope.mailcupLogin = ->
        console.log(self)
        email = $scope.App.email
        password = $scope.App.password
        req =
          method: "POST"
          url: self.inboxAuthURL
          headers:
            "Content-Type": "application/json"
          data:
            email: email
            password: password

        $http(req).success(->
          $scope.App.showLogin = true
        ).error ->
          alert "failed"

      @inboxClientID = $inbox.appId()
      @inboxRedirectURL = window.location.href.split('/#')[0].replace('index.html', '')
      @loginHint = ''

      @clearToken = $auth.clearToken
      @token = () => $auth.token
      @needToken = () => $auth.needToken()

      @namespace = () => $namespaces.current()

      @theme = $cookieStore.get('baobab_theme') || 'light'
      @setTheme = (theme) =>
        @theme = theme
        $cookieStore.put('baobab_theme', theme)


      @toggleTheme = () =>
        @setTheme({light: 'dark', dark: 'light'}[@theme])


      @cssForTab = (path) =>
        if $location.path().indexOf(path) != -1
          'active'
        else
          ''

      @
    ])
