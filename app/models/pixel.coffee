Spine = require('spine')

class Pixel extends Spine.Model
  @configure 'Pixel', 'state', 'x', 'y'

module.exports = Pixel
