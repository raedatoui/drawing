Spine = require('spine')

module.exports = class Command extends Spine.Model
  @configure 'Command', 'name', 'args'

