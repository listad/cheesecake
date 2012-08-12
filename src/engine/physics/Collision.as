package engine.physics 
{
	import engine.geometry.Vector2D;
	
	public class Collision 
	{
		
		public function Collision(axis:Vector2D, distance: Number, bodyA:RigidBody , bodyB:RigidBody ) 
		{
			//trace(axis.x, axis.y);
			bodyA.position = bodyA.position.add( Vector2D.scale(axis, 0.5 * distance)  );
			bodyB.position = bodyB.position.subtract( Vector2D.scale(axis, 0.5 * distance)  );
		}
		
	}

}