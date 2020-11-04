import opengl

type
    Player* = ref object
        x*: Glfloat
        y*: Glfloat
        w*: Glfloat
        h*: Glfloat
        vX*: float
        vY*: float

proc draw*(this: Player) =
    glColor3f(255, 255, 255)

    glBegin(GL_QUADS)
    glVertex2f(this.x, this.y)
    glVertex2f(this.x + this.w, this.y)
    glVertex2f(this.x + this.w, this.y + this.h)
    glVertex2f(this.x, this.y + this.h)
    glEnd()