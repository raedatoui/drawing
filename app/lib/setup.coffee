require('spine')
require('spine/lib/local')
require('spine/lib/manager')
require('spine/lib/route')

#this is a good place to do settings that aren't related to spine
Spine.Controller.include
  view: (name, data = {}) ->
    v = require("views/#{name}")
    if v? then v(data) else throw "No template at #{name}"

  appendChild: (controller, model=null) ->
    controller.prepareWithModel model
    @append controller

  appendChildTo: (controller, container, model=null) ->
    controller.prepareWithModel model
    controller.appendTo container
