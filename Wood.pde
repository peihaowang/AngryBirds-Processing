
class Wood extends Box
{

  Wood(float x, float y, float w, float h){
    super(x, y, w, h);
  }
  
  boolean done() { return false; }
  
  void onDisplay()
  {
    Vec2 pos = box2d.getBodyPixelCoord(m_body);
    float a = m_body.getAngle();

    imageMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    if(m_w > m_h){
      image(imgWoodH, 0, 0, m_w, m_h);
    }else{
      image(imgWoodV, 0, 0, m_w, m_h);
    }
    popMatrix();
  }

  FixtureDef getFixture()
  {
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    // Parameters that affect physics
    fd.density = 30;
    fd.friction = 10.0;
    fd.restitution = 0.0;
    return fd;
  }

}
