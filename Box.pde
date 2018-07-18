
abstract class Box extends HitBody
{

  // Constructor
  Box(float x, float y, float w, float h)
  {
    super(HitBodyType.Box);
    
    m_w = w; m_h = h;
    makeBody(new Vec2(x, y), w, h);
  }

  boolean done()
  {
    return false;
  }
  
  abstract FixtureDef getFixture();

  protected void makeBody(Vec2 center, float w, float h)
  {
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w / 2);
    float box2dH = box2d.scalarPixelsToWorld(h / 2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = getFixture();
    fd.shape = sd;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    m_body = box2d.createBody(bd);
    m_body.createFixture(fd);
    m_body.setUserData(this);
    //body.setMassFromShapes();
  }

}
