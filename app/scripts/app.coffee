'use strict'

angular.module('staticshowdownApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ui.bootstrap',
  'firebase'
])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/manage',
        templateUrl: 'views/manage.html'
        controller: 'WorkoutCtrl'
      .otherwise
        redirectTo: '/'
