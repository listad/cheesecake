package tests {
	import engine.GameEngine;
	import engine.GameObject;
	import engine.geometry.Polygon;
	import engine.geometry.Vector2D;
	import engine.physics.Collider;
	import engine.physics.RigidBody;
	
	import flash.display.Sprite;
	
	public class CoarseCollisionExperiment extends Sprite {
		
		public function CoarseCollisionExperiment() {
			//stage.frameRate = 60;
			
			var gameEngine:GameEngine = new GameEngine();
			super.addChild(gameEngine);
			
			var gameObject:GameObject = new GameObject(100.0, 100.0, 1.4, "objectA");
			
			gameObject.collider = new Collider();
			gameObject.collider.polygon = Polygon.rect(50.0, 50.0);
			gameObject.rigidBody = new RigidBody();
			gameObject.rigidBody.addImpulse(new Vector2D(10.0, 5.0));
			gameObject.rigidBody.addTorque(200.0);
			
			gameEngine.addGameObject(gameObject);
			
			gameObject = new GameObject(200.0, 200.0, 1.4, "objectB");
			gameObject.collider = new Collider();
			gameObject.collider.polygon = Polygon.rect(50.0, 50.0);
			
			gameEngine.addGameObject(gameObject);
			
		}
		
	}
}