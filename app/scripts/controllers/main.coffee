'use strict'

angular.module('staticshowdownApp')
  .controller 'MainCtrl', ['$scope', '$firebase', '$location', ($scope, $firebase, $location) ->
    workoutRef = new Firebase("//torid-fire-5454.firebaseIO.com/workouts")
    workouts = $firebase(workoutRef);
    $scope.play = ->
      keys = workouts.$getIndex()
      hit = keys[Math.floor(Math.random() * keys.length)]
      $location.path("/workout/#{hit}")
  ]

angular.module('staticshowdownApp')
  .controller 'WorkoutCtrl', ['$scope', '$firebase', ($scope, $firebase) ->
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

    # For submission
    $scope.save = ->
      # Sanitize
      subMuscleGroups = []
      equipments = []
      for key, checked of $scope.workout.subMuscleGroups
        subMuscleGroups.push(key) if checked
      for key, checked of $scope.workout.equipments
        equipments.push(key) if checked
      $scope.workout.subMuscleGroups = subMuscleGroups
      $scope.workout.equipments = equipments

      workoutRef = new Firebase("//torid-fire-5454.firebaseIO.com/workouts")
      workouts = $firebase(workoutRef)
      workouts.$add($scope.workout)

      alert("Workout Saved!")
  ]

angular.module('staticshowdownApp')
  .controller 'WorkoutDetailCtrl', ['$scope', '$firebase', '$routeParams', ($scope, $firebase, $routeParams) ->
    workoutRef = new Firebase("//torid-fire-5454.firebaseIO.com/workouts")
    workouts = $firebase(workoutRef)
    workouts.$on 'loaded', ->
      $scope.workout = workouts[$routeParams.key]
  ]
