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

    # Reset
    $scope.reset = ->
      $scope.submitted = false
      $scope.workout = {
        subMuscleGroups: {}
        equipments: {}
      }
    $scope.reset()

    # For submission
    $scope.save = ->
      $scope.submitted = true
      if $scope.workoutForm.$invalid
        alert("Form is invalid")
        return

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
      $scope.reset()
  ]

angular.module('staticshowdownApp')
  .controller 'WorkoutDetailCtrl', ['$scope', '$firebase', '$routeParams', ($scope, $firebase, $routeParams) ->
    workoutRef = new Firebase("//torid-fire-5454.firebaseIO.com/workouts")
    workouts = $firebase(workoutRef)
    workouts.$on 'loaded', ->
      $scope.workout = workouts[$routeParams.key]
  ]

angular.module('staticshowdownApp')
  .controller 'WorkoutListCtrl', ['$scope', '$firebase', ($scope, $firebase) ->
    workoutRef = new Firebase("//torid-fire-5454.firebaseIO.com/workouts")
    $scope.workouts = $firebase(workoutRef)
    $scope.delete = (key) ->
      if confirm("Delete workout \"#{$scope.workouts[key].name}\"?")
        $scope.workouts.$remove(key)

    # Filter stuffs
    $scope.query = {
      name: ""
    }

    # TODO: Don't Repeat Yourself
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
  ]

angular.module('fitRouletteFilters', [])
  .filter 'workoutFilter', ->
    (workouts, query) ->
      result = {}
      angular.forEach workouts, (workout, key) ->
        if workout.name.indexOf(query.name) != -1
            result[key] = workout
      return result
