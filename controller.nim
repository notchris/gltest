type
    Controller* = ref object
        up*: bool
        down*: bool
        left*: bool
        right*: bool

proc update*(this: Controller, up: bool, down: bool, left: bool, right: bool) =
    this.up = up
    this.down = down
    this.left = left
    this.right = right