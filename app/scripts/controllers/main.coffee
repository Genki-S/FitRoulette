'use strict'

angular.module('staticshowdownApp')
  .controller 'MainCtrl', ['$scope', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
  ]
