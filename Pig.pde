
abstract class Pig extends HitBody
{
  
  int m_timer;
  int m_timeDying;
  int m_durationDying;
  int m_hp;

  // Constructor
  Pig(float x, float y, float w, float h)
  {
    super(HitBodyType.Pig);
    
    m_w = w; m_h = h;
    m_enableCollision = true;

    makeBody(new Vec2(x, y), m_w, m_h);

    m_timer = 0;
    m_timeDying = -1; m_durationDying = 30;
  }
  
  boolean isDying(){return m_timeDying >= 0;}
  
  void onImpulseCollision(ContactImpulse impulse)
  {
    float impulseVal = maximumNormalImpulse(impulse);
    float threshold = 10000;
    if(impulseVal > threshold){
      float harm = (impulseVal - threshold) / 20;
      m_hp -= harm;
    }
  }
  
  boolean done()
  {
    boolean hasDone = false;

    /*ContactEdge ce = m_body.getContactList();
    while(ce != null){
      Contact c = ce.contact;
      ContactEdge prev = ce.prev;
      ce = ce.next;
      
      if(prev == null) continue;
      
      WorldManifold worldManifold = new WorldManifold(); c.getWorldManifold(worldManifold);
      //println("World", worldManifold.normal);

      Collision.PointState[] state1 = new Collision.PointState[2];
      Collision.PointState[] state2 = new Collision.PointState[2];
      Manifold oldManifold = prev.contact.getManifold();
      Collision.getPointStates(state1, state2, oldManifold, c.getManifold());
      //println("State", state2[0]);
      if(state2[0] != Collision.PointState.NULL_STATE && state2[0] != Collision.PointState.REMOVE_STATE){
        Body bodyA = c.getFixtureA().getBody();
        Body bodyB = c.getFixtureB().getBody();

        Vec2 point = worldManifold.points[0];
        Vec2 vA = bodyA.getLinearVelocityFromWorldPoint(point);
        Vec2 vB = bodyB.getLinearVelocityFromWorldPoint(point);
        float approachVel = abs(Vec2.dot(vB.sub(vA), worldManifold.normal));
        float harm = approachVel * 200; m_hp -= harm;
        if(approachVel > 0.0){
            m_hp -= approachVel * 200;
        }
      }
    }*/
    
    if(m_hp <= 0){
      if(m_timeDying < 0){
        m_timeDying = m_timer;
      }else{
        if(m_timer - m_timeDying > m_durationDying){
          hasDone = true;
        }
      }
    }
    return hasDone;
  }

  // Drawing the box
  void onDisplay()
  {
    m_timer++;
    Vec2 pos = box2d.getBodyPixelCoord(m_body);
    float a = m_body.getAngle();
    onDraw(pos.x, pos.y, -a);
  }

  abstract void onDraw(float x, float y, float a);
  abstract Shape getShape();
  abstract FixtureDef getFixture();

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
