package tests {
	import engine.GameEngine;
	import engine.GameObject;
	import engine.geometry.Polygon;
	import engine.geometry.Vector2D;
	import engine.physics.Collider;
	import engine.physics.PhysicsMaterial;
	import engine.physics.RigidBody;
	import flash.display.StageQuality;
	import flash.filters.GlowFilter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CoarseCollisionExperiment extends Sprite {
		private var gameEngine:GameEngine;
		
		public function CoarseCollisionExperiment() {
			//stage.frameRate = 60;
			
			gameEngine = new GameEngine();
			super.addChild(gameEngine);
			var i:int;
			var gameObject:GameObject;
			///*
			for(i = 0; i < 10; i++) {
			
				gameObject = new GameObject(50 + Math.random() * 900.0, 100.0, 1.4, "objectA");
				gameObject.rigidBody = new RigidBody();
				gameObject.collider = new Collider();
				
				gameObject.collider.polygon = Polygon.rect(5 + Math.random() * 15, 5 + Math.random() * 15);//Polygon.convexRegular(3 + Math.floor(Math.random() * 3), 5 + Math.random() * 15);
				
				//gameObject.rigidBody.addImpulse(new Vector2D(0.0, 10.0));
				gameObject.rigidBody.addTorque(500.0);
				gameObject.rigidBody.drag = 0.1;
				gameEngine.addGameObject(gameObject);
				gameObject.rigidBody.gravity = new Vector2D(0.0, 25.0);
				//gameObject.filters = [new GlowFilter(0xFF5555, 1.0, 2.0, 2.0, 2.0, 2.0, false, false)];
				
				//gameObject.collider.polygon.draw(gameObject.graphics, 0.0, 0xFFEEEE, 0.0, 0xFFAAAA, 1.0)
			}
			
			for(i = 0; i < 10; i++) {
			
				gameObject = new GameObject(50 + Math.random() * 900.0, 100.0, 1.4, "objectA");
				gameObject.rigidBody = new RigidBody();
				gameObject.collider = new Collider();
				
				gameObject.collider.circle = 5 + Math.random()*15;
				
				gameObject.rigidBody.addTorque(500.0);
				gameObject.rigidBody.drag = 0.1;
				gameEngine.addGameObject(gameObject);
				gameObject.rigidBody.gravity = new Vector2D(0.0, 25.0);
			}
			
			
			
			//*/
			/*for(i = 0; i < 20; i++) {
				gameObject = new GameObject(10 + Math.random() * 980.0, (1.0 - Math.random() * Math.random()) * 1000.0, Math.random() * Math.PI, "collider");
				gameObject.collider = new Collider();
				//gameObject.collider.polygon = Polygon.rect(5 + Math.random()*20.0, 5 + Math.random()*5.0);
				//gameObject.collider.polygon.draw(gameObject.graphics, 0.0, 0x330000, 0.0, 0xAAAAAA, 1.0)
				gameObject.collider.circle = 15 + Math.random()*15;
				gameEngine.addGameObject(gameObject);
			}*/
			for(i = 0; i < 25; i++) {
				gameObject = new GameObject(10 + Math.random() * 980.0, (1.0 - Math.random() * Math.random()) * 1000.0, Math.random() * Math.PI, "collider");
				gameObject.collider = new Collider();
				gameObject.collider.polygon = Polygon.rect(155 + Math.random()*25.0, 5 + Math.random()*15.0);
				//gameObject.collider.polygon.draw(gameObject.graphics, 0.0, 0x330000, 0.0, 0xAAAAAA, 1.0)
				//gameObject.collider.circle = 5 + Math.random()*40;
				gameEngine.addGameObject(gameObject);
			}
			
			
			super.addEventListener(Event.ENTER_FRAME, this.enterFrameEventListener);
			
			/*var gameObject:GameObject = new GameObject(150.0, 150.0, 1.4, "objectA");
				gameObject.rigidBody = new RigidBody();
				gameObject.collider = new Collider();
				
				gameObject.collider.polygon = Polygon.rect(100.0, 100.0);
				gameObject.rigidBody.drag = 0.1;
				gameEngine.addGameObject(gameObject);
				
				
			var gameObject:GameObject = new GameObject(200.0, 200.0, 1.5, "objectB");
				gameObject.rigidBody = new RigidBody();
				gameObject.collider = new Collider();
				
				gameObject.collider.polygon = Polygon.rect(200.0, 100.0);
				gameObject.rigidBody.drag = 0.1;
				gameEngine.addGameObject(gameObject);*/
				
			
			
			
		}
		
		private function enterFrameEventListener(event:Event):void {
			var rigidbodies:Vector.<RigidBody> = gameEngine.physics.rigidbodies;
			var length:int = gameEngine.physics.rigidbodies.length;
			for(var i:int = 0; i < length; i++) {
				var rigidbody:RigidBody = rigidbodies[i];
				if(rigidbody.state.y > 1000) {
					rigidbody.state.y = 50;
					rigidbody.state.x = 50 + Math.random() * 900.0;
				}
			}
		}
		
	}//class
}