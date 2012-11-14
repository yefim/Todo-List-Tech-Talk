$ ->
  class window.Todo extends Backbone.Model
    defaults:
      title: "empty todo..."
      done: false

    toggle: () ->
      @set "done", !@get("done")

    clear: () ->
      @destroy()

  class window.TodoList extends Backbone.Collection
    model: Todo
    localStorage: new Backbone.LocalStorage("todo")

  window.Todos = new TodoList()

  class window.TodoView extends Backbone.View
    template: Handlebars.templates.todo
    events: {
      'click .destroy' : 'clear'
    }
    initialize: () ->
      @model.on("all", @render, @)
    clear: () ->
      @model.clear()
      @remove()
    render: () ->
      @$el.html @template(@model.toJSON())
      return @
  class window.AppView extends Backbone.View
    template: Handlebars.templates.app
    events:
      'keypress #new-todo' : 'createOnEnter'
    createOnEnter: (e) ->
      if e.keyCode is 13
        Todos.create(title: @input.val())
        @input.val('')
    initialize: () ->
      @input = $("#new-todo")
      @footer = $("footer")
      Todos.on("all", @render, @)
      Todos.on("fetched", @addAll, @)
      Todos.on("add", @addOne, @)
      Todos.fetch()
      Todos.trigger("fetched")
    addOne: (todo) ->
      view = new TodoView(model: todo)
      $("#todo-list").append view.render().el
    addAll: () ->
      Todos.each @addOne
    render: () ->
      @footer.html @template(done: Todos.length)

  window.App = new AppView(el: $("#todo-app"))
