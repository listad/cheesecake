package tests {
	import engine.GameEngine;
	import engine.GameObject;
	import engine.geometry.Polygon;
	import engine.geometry.Vector2D;
	
	import flash.display.Sprite;
	
	public class CoarseCollisionExperiment extends Sprite {
		
		public function CoarseCollisionExperiment() {
			//stage.frameRate = 60;
			
			var gameEngine:GameEngine = new GameEngine();
			super.addChild(gameEngine);
			
			var gameObject:GameObject = new GameObject();
			gameEngine.addGameObject(gameObject);
			
			
			gameObject.state.x = 100;
			gameObject.state.y = 100;
			gameObject.state.rotation = 0;
			
			gameObject.collider.polygon = Polygon.rect(50.0, 50.0);
			gameObject.rigidBody.addImpulse(new Vector2D(10.0, 0));
		}
		
	}
}