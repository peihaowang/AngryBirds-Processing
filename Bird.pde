
abstract class Bird extends HitBody
{

  PVector m_pos; float m_rotation;
  
  int m_timer;
  int m_timeStop;
  int m_durationDying;

  // Constructor
  Bird(float w, float h)
  {
    super(HitBodyType.Bird);
    
    m_pos = new PVector(); m_rotation = 0.0;
    m_w = w; m_h = h;

    m_timer = 0;
    m_timeStop = -1; m_durationDying = 100;
  }
  
  boolean done()
  {
    boolean hasDone = false;
    if(m_body != null){
      Vec2 v = m_body.getLinearVelocity();
      if(v.length() < 1.0){
        if(m_timeStop < 0){
          m_timeStop = m_timer;
        }else{
          if(m_timer - m_timeStop > m_durationDying){
            hasDone = true;
          }
        }
      }else{
        if(m_timeStop >= 0) m_timeStop = -1;
      }
    }
    return hasDone;
  }

  // Drawing the box
  void onDisplay()
  {
    m_timer++;
    // Before init the physical properties, use m_pos to locate and render bird
    if(m_body != null){
      Vec2 pos = box2d.getBodyPixelCoord(m_body);
      float a = m_body.getAngle();
      onDraw(pos.x, pos.y, -a);
    }else{
      onDraw(m_pos.x, m_pos.y, m_rotation);
    }
  }

  abstract void onDraw(float x, float y, float a);
  abstract void onEmit();

  abstract Shape getShape();
  abstract FixtureDef getFixture();
  
  void go(float vel, Vec2 target)
  {
    makeBody(new Vec2(m_pos.x, m_pos.y), m_w, m_h);

    Vec2 bodyVec = m_body.getWorldCenter();
    Vec2 worldTarget = box2d.coordPixelsToWorld(target.x, target.y);
    worldTarget.subLocal(bodyVec);
    worldTarget.normalize();
    worldTarget.mulLocal(vel);
    m_body.setLinearVelocity(worldTarget);
  }
  
  boolean gone()
  {
    return m_body != null;
  }

  protected void makeBody(Vec2 center, float w, float h)
  {
    Shape sd = getShape();

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
