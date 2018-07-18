
class RedBird extends Bird
{

  // Constructor
  RedBird()
  {
    super(40, 40);
  }

  void onDraw(float x, float y, float a)
  {
    imageMode(CENTER);
    rectMode(CENTER);
    ellipseMode(CENTER);
    pushMatrix();
    translate(x, y);
    rotate(a);
    image(imgRedBird, 0, 0, m_w, m_h);
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
    fd.density = 100;
    fd.friction = 3.0;
    fd.restitution = 0.0;
    return fd;
  }
  
  void onEmit()
  {
    // No effect
  }

}
