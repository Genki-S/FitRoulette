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

angular.module('staticshowdownApp')
  .controller 'WorkoutCtrl', ['$scope', ($scope) ->
    # Available Values
    $scope.muscleGroups = [
      "abs"
      "back"
      "biceps"
      "chest"
      "forearm"
      "glutes"
      "shoulders"
      "triceps"
      "upper legs"
      "lower legs"
      "fullbody"
    ]
    $scope.types = [
      "strength"
      "plyometrics"
      "cardio"
      "stretching"
    ]
    $scope.equipments = [
      "balance ball"
      "band"
      "barbell"
      "bench"
      "dumbbell"
      "foam roller"
      "kettlebell"
    ]
    $scope.difficulties = [
      "beginner"
      "intermediate"
      "expert"
    ]

    # Construct
    $scope.workout = {
      subMuscleGroups: {}
      equipments: {}
    }
  ]
