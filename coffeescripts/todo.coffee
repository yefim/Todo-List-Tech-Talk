$ ->
  class window.Todo extends Backbone.Model
    defaults:
      title: "empty todo..."
      done: false

    toggle: () ->
      @set "done", !@get("done")

  class window.TodoList extends Backbone.Collection
