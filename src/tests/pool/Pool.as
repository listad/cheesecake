package tests.pool {
	import flash.display.Sprite;
	import engine.GameEngine;
	import engine.GameObject;
	import engine.physics.Collider;
	import engine.geometry.Polygon;
	import engine.physics.RigidBody;
	import engine.geometry.Vector2D;
	import engine.physics.PhysicsMaterial;
	import flash.display.Stage;

	public class Pool extends Sprite {
		private var _gameEngine:GameEngine;
		var _st:Stage;
		public function Pool(st:Stage) {
			_st = st;
			this._gameEngine = new GameEngine();
			super.addChild(this._gameEngine);
			
			var gameObject:GameObject;
			
			
			var rubber:PhysicsMaterial = new PhysicsMaterial(0, 1.0);
			
			gameObject = new GameObject(0, 22+344/2, 0.0, "LEFT BORDER");
			gameObject.collider = new Collider();
			gameObject.collider.material = rubber;
			gameObject.collider.polygon = Polygon.fromVertices(
				new <Number>[0,-172+6, 22,-150+6, 22,150-6, 0,172-6]	);
			this._gameEngine.addGameObject(gameObject);
			
			gameObject = new GameObject(366+366, 194, -Math.PI, "RIGHT BORDER");
			gameObject.collider = new Collider();
			gameObject.collider.material = rubber;
			gameObject.collider.polygon = Polygon.fromVertices(
				new <Number>[0,-172+6, 22,-150+6, 22,150-6, 0,172-6]	);
			this._gameEngine.addGameObject(gameObject);
			
			gameObject = new GameObject(22+344/2, 0, 0, "LEFT-UP BORDER");
			gameObject.collider = new Collider();
			gameObject.collider.material = rubber;
			gameObject.collider.polygon = Polygon.fromVertices(
				new <Number>[-172+6,0, 162-6,0, 156-6,22, -150+6,22]	);
			this._gameEngine.addGameObject(gameObject);
			
			gameObject = new GameObject(366+344/2, 0, 0, "RIGHT-UP BORDER");
			gameObject.collider = new Collider();
			gameObject.collider.material = rubber;
			gameObject.collider.polygon = Polygon.fromVertices(
				new <Number>[-162+6,0, 172-6,0,  150-6,22, -156+6,22]	);
			this._gameEngine.addGameObject(gameObject);
			
			gameObject = new GameObject(366+344/2, 388, -Math.PI, "RIGHT-DOWN BORDER");
			gameObject.collider = new Collider();
			gameObject.collider.material = rubber;
			gameObject.collider.polygon = Polygon.fromVertices(
				new <Number>[-172+6,0, 162-6,0, 156-6,22, -150+6,22]	);
			this._gameEngine.addGameObject(gameObject);
			
			gameObject = new GameObject(22+344/2, 388, -Math.PI, "LEFT-DOWN BORDER");
			gameObject.collider = new Collider();
			gameObject.collider.material = rubber;
			gameObject.collider.polygon = Polygon.fromVertices(
				new <Number>[-162+6,0, 172-6,0,  150-6,22, -156+6,22]	);
			this._gameEngine.addGameObject(gameObject);
			
			var main:GameObject = this.placeBall(366+344/2, 388/2);
			//main.rigidBody.addImpulse( new Vector2D(-500, 0) );
			
			this.placeBall(100, 388/2 - 60);
			this.placeBall(100, 388/2 - 30);
			this.placeBall(100, 388/2);
			this.placeBall(100, 388/2 + 30);
			this.placeBall(100, 388/2 + 60);
			
			this.placeBall(126, 388/2 - 15 - 30);
			this.placeBall(126, 388/2 - 15);
			this.placeBall(126, 388/2 + 15);
			this.placeBall(126, 388/2 + 15 + 30);
			
			this.placeBall(152, 388/2 - 30);
			this.placeBall(152, 388/2);
			this.placeBall(152, 388/2 + 30);
			
			this.placeBall(178, 388/2 - 15);
			this.placeBall(178, 388/2 + 15);
			
			this.placeBall(204, 388/2);
			
		}
		
		private function placeBall(x:Number, y:Number):GameObject {
			var gameObject:GameObject = new Ball(x, y, _st);
			this._gameEngine.addGameObject(gameObject);
			return gameObject;
		}
	}
}
import engine.GameObject;
import engine.physics.Collider;
import engine.physics.RigidBody;
import engine.physics.PhysicsMaterial;
import flash.events.MouseEvent;
import flash.display.Stage;
import engine.geometry.Vector2D;
import flash.filters.GlowFilter;
import engine.geometry.Polygon;

class Ball extends GameObject {
	var _stage:Stage;
	var mdp:Vector2D;
	public function Ball(x:Number, y:Number, st:Stage) {
		super(x, y, 0, "BALL");
		super.collider = new Collider();
		super.rigidBody = new RigidBody();
		super.collider.circle = 12;
		//super.collider.polygon = Polygon.convexRegular(20, 14);
		super.rigidBody.drag = 0;
		super.collider.material = new PhysicsMaterial(0, 1.0);
		
		_stage = st;
		super.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}
	private function onMouseDown(mouseEvent:MouseEvent):void {
		//trace(_stage);
		mdp = new Vector2D(_stage.mouseX, _stage.mouseY);
		_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		super.filters = [ new GlowFilter(0xff0000, 1, 2, 2, 10, 3) ];
		
		_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}
	private function onMouseUp(mouseEvent:MouseEvent):void {
		super.filters = [];
		var mup:Vector2D = new Vector2D(_stage.mouseX, _stage.mouseY);
		var diff:Vector2D = mup.subtract(mdp).scale(1);
		super.rigidBody.addImpulse(diff);
		_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}
	private function onMouseMove(mouseEvent:MouseEvent):void {
		
		var mmp:Vector2D = new Vector2D(_stage.mouseX, _stage.mouseY);
		
		
	}
}