import staticglfw
import opengl
import util

type
    Platform* = ref object
        x*: Glfloat
        y*: Glfloat
        w*: Glfloat
        h*: Glfloat
        color*: Color

proc draw*(this: Platform) =
    glColor3f(this.color.r, this.color.g, this.color.b)

    glBegin(GL_QUADS)
    glVertex2f(this.x, this.y)
    glVertex2f(this.x + this.w, this.y)
    glVertex2f(this.x + this.w, this.y + this.h)
    glVertex2f(this.x, this.y + this.h)
    glEnd()