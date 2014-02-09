'use strict'

angular.module('staticshowdownApp')
  .controller 'MainCtrl', ['$scope', ($scope) ->
    $scope.workouts = [
      {
        name: "push up"
        mainMuscleGroup: "chest"
        subMuscleGroups: ["triceps"]
        type: "strength"
        equipments: []
        difficulty: "beginner"
      }
      {
        name: "barbell bench press"
        mainMuscleGroup: "chest"
        subMuscleGroups: []
        type: "strength"
        equipments: ["barbell"]
        difficulty: "intermediate"
      }
    ]
  ]
