
class NormalPig extends Pig
{

  // Constructor
  NormalPig(float x, float y)
  {
    super(x, y, 60, 60);
    m_hp = 100;
  }

  // Drawing the box
  void onDraw(float x, float y, float a)
  {
    rectMode(CENTER);
    ellipseMode(CENTER);
    pushMatrix();
    translate(x, y);
    rotate(a);
    fill(0, 200, 0);
    stroke(0, 100, 0);
    if(!isDying()){
      image(imgPig, 0, 0, m_w, m_h);
    }else{
      image(imgPigDying, 0, 0, m_w, m_h);
    }
    popMatrix();
  }
  
  Shape getShape()
  {
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(m_w / 2);
    return cs;
  }

  FixtureDef getFixture()
  {
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    // Parameters that affect physics
    fd.density = 30;
    fd.friction = 3.0;
    fd.restitution = 0.0;
    return fd;
  }

}
