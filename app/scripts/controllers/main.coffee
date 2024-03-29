'use strict'

angular.module('fitRouletteApp')
  .controller 'MainCtrl', ['$scope', '$firebase', '$location', '$modal', '$filter', 'localStorageService', ($scope, $firebase, $location, $modal, $filter, localStorageService) ->
    workoutRef = new Firebase("//torid-fire-5454.firebaseIO.com/workouts")
    $scope.workouts = $firebase(workoutRef);
    $scope.play = ->
      filteredWorkouts = $filter('workoutFilter')($scope.workouts, $scope.queryObj)
      keys = []
      for k, v of filteredWorkouts
        keys.push(k)
      if keys.length == 0
        alert("No Workout Found")
        return
      hit = keys[Math.floor(Math.random() * keys.length)]
      $location.path("/workout/#{hit}")

    # TODO: Don't Repeat Yourself
    $scope.filter = ->
      modalInstance = $modal.open
        templateUrl: 'views/filter.html'
        controller: 'FilterCtrl'
        resolve:
          queryObj: ->
            $scope.queryObj

      modalInstance.result.then (queryObj) ->
        $scope.queryObj = queryObj

    $scope.queryObj = localStorageService.get('fitRouletteQuery')
    unless $scope.queryObj?
      $scope.queryObj = {
        name: ""
        mainMuscleGroup: ""
        equipments: {}
        type: ""
        difficulty: ""
      }
  ]

angular.module('fitRouletteApp')
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

angular.module('fitRouletteApp')
  .controller 'WorkoutDetailCtrl', ['$scope', '$firebase', '$routeParams', '$sce', ($scope, $firebase, $routeParams, $sce) ->
    workoutRef = new Firebase("//torid-fire-5454.firebaseIO.com/workouts")
    workouts = $firebase(workoutRef)
    workouts.$on 'loaded', ->
      $scope.workout = workouts[$routeParams.key]
    $scope.youtubeSrc = (id) ->
      $sce.trustAsResourceUrl('http://www.youtube.com/embed/' + id)
  ]

angular.module('fitRouletteApp')
  .controller 'WorkoutListCtrl', ['$scope', '$firebase', '$modal', ($scope, $firebase, $modal) ->
    workoutRef = new Firebase("//torid-fire-5454.firebaseIO.com/workouts")
    $scope.workouts = $firebase(workoutRef)
    $scope.delete = (key) ->
      if confirm("Delete workout \"#{$scope.workouts[key].name}\"?")
        $scope.workouts.$remove(key)

    # Filter stuffs
    $scope.filter = ->
      modalInstance = $modal.open
        templateUrl: 'views/filter.html'
        controller: 'FilterCtrl'
        resolve:
          queryObj: ->
            $scope.queryObj

      modalInstance.result.then (queryObj) ->
        $scope.queryObj = queryObj

    $scope.queryObj = {
      name: ""
      mainMuscleGroup: ""
      equipments: {}
      type: ""
      difficulty: ""
    }
  ]

angular.module('fitRouletteApp')
  .controller 'FilterCtrl', ['$scope', '$modalInstance', 'localStorageService', 'queryObj', ($scope, $modalInstance, localStorageService, queryObj) ->
    $scope.queryObj = angular.copy(queryObj)

    $scope.ok = ->
      localStorageService.add('fitRouletteQuery', $scope.queryObj)
      $modalInstance.close($scope.queryObj)
    $scope.cancel = ->
      $modalInstance.dismiss('cancel')
    $scope.clear = ->
      # TODO: Don't Repeat Yourself
      $scope.queryObj = {
        name: ""
        mainMuscleGroup: ""
        equipments: {}
        type: ""
        difficulty: ""
      }

    # TODO: Don't Repeat Yourself
    # Available Values
    $scope.muscleGroups = [
      ""
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
      ""
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
      ""
      "beginner"
      "intermediate"
      "expert"
    ]
  ]

angular.module('fitRouletteFilters', [])
  .filter 'workoutFilter', ->
    (workouts, query) ->
      result = {}
      # TODO: Super ugly. Refactor.
      angular.forEach workouts, (workout, key) ->
        add = true
        unless (workout.name != "" and workout.name.indexOf(query.name) != -1) and
          (workout.mainMuscleGroup != "" and workout.mainMuscleGroup.indexOf(query.mainMuscleGroup) != -1) and
          (workout.type != "" and workout.type.indexOf(query.type) != -1) and
          (workout.difficulty != "" and workout.difficulty.indexOf(query.difficulty) != -1)
            add = false
        for equipment, checked of query.equipments
          if checked and (not workout.equipments?)
            add = false
          else if checked and (not (equipment in workout.equipments))
            add = false
        result[key] = workout if add
      return result
  .filter 'objLength', ->
    (obj) ->
      (k for own k of obj).length
  .filter 'trueKeys', ->
    (obj) ->
      keys = []
      for own k of obj
        keys.push(k) if obj[k]
      return keys
