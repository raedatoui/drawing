require = window.require

describe 'The Renderer Controller', ->
  Renderer = require('controllers/renderer')
  Command = require('models/command')

  #["C 20 15", "L 5 2 20 2", "L 17 6 17 15", "R 2 5 13 12", "B 10 3 #F44"]
  beforeEach ->
    element = $("<div />")
    ## create an instance of the controller
    @renderer = new Renderer(el: element)
    ## start by creating a canvas
    command = new Command
      name: 'C'
      args:
        w: 20
        h: 15
    @renderer.consume command

  it 'can draw a 20x15 canvas', ->
    ## should have 15 rows
    expect(@renderer.cells.length).toBe 15
    ## should set properties
    expect(@renderer.canvasWidth).toBe 20
    expect(@renderer.canvasHeight).toBe 15
    ## check size of double array
    for i in [0..14]
      expect(@renderer.cells[i].length).toBe 20 #each row is 20 cells wide

  it 'can draw a horizontal line L 5 2 20 2', ->
    command = new Command
      name: 'L'
      args:
        x1: 5
        y1: 2
        x2: 20
        y2: 2
    @renderer.consume command

    ## first cells in 2nd row are blank
    for i in [0..3]
      expect(@renderer.cells[1][i].state).toBe ''

    ## next 16 cells are marked with x
    for i in [4..19]
      expect(@renderer.cells[1][i].state).toBe 'x'

  it 'can draw a vertical line L 17 6 17 15', ->
    command = new Command
      name: 'L'
      args:
        x1: 17
        y1: 6
        x2: 17
        y2: 15
    @renderer.consume command

    for j in [0..4]
      expect(@renderer.cells[j][16].state).toBe ''
    for j in [5..14]
      expect(@renderer.cells[j][16].state).toBe 'x'


  it 'can draw a rectangle', ->
    command = new Command
      name: 'R'
      args:
        x1: 2
        y1: 5
        x2: 13
        y2: 12
    @renderer.consume command

    ## check the top line is marked with x
    for i in [1..12]
      expect(@renderer.cells[4][i].state).toBe 'x'

    ## check that the bottom line is drawn
    for i in [1..12]
      expect(@renderer.cells[11][i].state).toBe 'x'

    ## check that the left line is drawn
    for j in [5..11]
      expect(@renderer.cells[j][1].state).toBe 'x'

    ## check that the right line is drawn
    for j in [5..11]
      expect(@renderer.cells[j][12].state).toBe 'x'

  it 'can flood fill the canvas with red', ->
    ## add a horizontal line
    hl = new Command
      name: 'L'
      args:
        x1: 5
        y1: 2
        x2: 20
        y2: 2
    @renderer.consume hl

    ## add a vertical line
    vl = new Command
      name: 'L'
      args:
        x1: 17
        y1: 6
        x2: 17
        y2: 15
    @renderer.consume vl

    ## add a rectangle
    rect = new Command
      name: 'R'
      args:
        x1: 2
        y1: 5
        x2: 13
        y2: 12
    @renderer.consume rect

    fill = new Command
      name: 'B'
      args:
        x: 10
        y: 3
        c: '#f44'
    @renderer.consume fill,false

    #first cell is red

    expect(@renderer.cells[0][0].state).toBe 'o'
    expect(@renderer.cells[0][0].el.css('color')).toBe 'rgb(255, 68, 68)'
    ## cell inside the rectangle
    expect(@renderer.cells[5][5].state).toBe ''

    ## top left edge of the rect
    expect(@renderer.cells[4][1].state).toBe 'x'
    expect(@renderer.cells[14][8].state).toBe 'o'
    expect(@renderer.cells[5][18].state).toBe 'o'
