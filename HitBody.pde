
enum HitBodyType{None, Boundary, Box, Bird, Pig};

abstract class HitBody
{

  HitBodyType m_type;

  Body m_body;
  float m_w; float m_h;

  boolean m_enableCollision;

  HitBody(HitBodyType type)
  {
    m_type = type;
    m_enableCollision = false;
  }

  void onUpdate()
  {
    onDisplay();
  }

  abstract boolean done();
  boolean onIntrospect()
  {
    boolean d = done();
    if(d) killBody();
    return d;
  }

  abstract void onDisplay();

  protected abstract void makeBody(Vec2 center, float w, float h);
  void killBody()
  {
    box2d.destroyBody(m_body);
  }
  
  // Serveral method to calculate magnitude of impulse in collision
  float averageNormalImpulse(ContactImpulse impulse)
  {
    float total = 0.0;
    for(int i = 0; i < impulse.normalImpulses.length; i++){
      total += impulse.normalImpulses[i];
    }
    return total / impulse.normalImpulses.length;
  }
  
  float maximumNormalImpulse(ContactImpulse impulse)
  {
    float max = 0.0;
    for(int i = 0; i < impulse.normalImpulses.length; i++){
      if(max < impulse.normalImpulses[i]) max = impulse.normalImpulses[i];
    }
    return max;
  }
  
  void onImpulseCollision(ContactImpulse impulse) { /* Do nothing by default */ }

  //void handleCollision(Contact c, Contact prev, Contact next)
  //{
  //  if(prev == null) return;

  //  WorldManifold worldManifold = new WorldManifold(); c.getWorldManifold(worldManifold);
    
  //  Collision.PointState[] state1 = new Collision.PointState[2];
  //  Collision.PointState[] state2 = new Collision.PointState[2];
  //  Manifold oldManifold = prev.getManifold();
  //  Collision.getPointStates(state1, state2, oldManifold, c.getManifold());

  //  if(state2[0] != Collision.PointState.NULL_STATE && state2[0] != Collision.PointState.REMOVE_STATE){
  //    Body bodyA = c.getFixtureA().getBody();
  //    Body bodyB = c.getFixtureB().getBody();
      
  //    Vec2 point = worldManifold.points[0];
  //    Vec2 vA = bodyA.getLinearVelocityFromWorldPoint(point);
  //    Vec2 vB = bodyB.getLinearVelocityFromWorldPoint(point);
  //    float approachVel = abs(Vec2.dot(vB.sub(vA), worldManifold.normal));
  //    impulseCollision(approachVel);
  //  }
  //}

}
