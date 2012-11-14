$ ->
  class window.Todo extends Backbone.Model
    defaults:
      title: "empty todo..."
      done: false

    toggle: () ->
      @set "done", !@get("done")

  class window.TodoList extends Backbone.Collection
    model: Todo
    localStorage: new Backbone.LocalStorage("todo")

  Todos = new TodoList()

  class window.TodoView extends Backbone.View
    template: Handlebars.templates.todo
    events: {
      'click .destroy' : 'clear'
      'click .done'    : 'toggleTodo'
    }
    initialize: () ->
      @model.on("all", @render, @)
    clear: () ->
      @model.destroy()
      @remove()
    toggleTodo: () ->
      @model.toggle()
    render: () ->
      @$el.html @template(@model.toJSON())
      return @
