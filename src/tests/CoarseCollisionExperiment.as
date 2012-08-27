package tests {
	import engine.geometry.Matrix2D;
	import engine.geometry.Polygon;
	import engine.geometry.Vector2D;
	import engine.physics.CollisionGeometry;
	import engine.physics.Friction;
	import engine.physics.Gravity;
	import engine.physics.PhysicsSandbox;
	import engine.physics.RigidBody;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	public class CoarseCollisionExperiment extends Sprite {
		private var _rigidBody:RigidBody;
		private var _mouseDownPosition:Vector2D = new Vector2D();
		private var _mouseDown:Boolean = false;
		var sandbox:PhysicsSandbox;
		
		private var _bodies:Vector.<RigidBody> = new Vector.<RigidBody>();
		
		public function CoarseCollisionExperiment(stage:Stage) {
			stage.frameRate = 60;
			
			sandbox = new PhysicsSandbox();
			
			
			super.addChild(sandbox);
			
			var block:RigidBody;
			for(var i:int = 0; i < 30; i++) {
				
			
			block = new RigidBody(50 + Math.random()*900, Math.random()*100, 0.4, 1, 500, 0.0, 0.0, CollisionGeometry.convexRegular(3+Math.round(Math.random()*2), 10+20*Math.random() ), true );

				block.addForce(new Friction(0.1));
				block.addForce(new Gravity(2000.0))
				sandbox.addRigidBody(block);
				_bodies.push(block);
				//block.addImpulse( new Vector2D(0, 150) );
			
					
			}
			//
			
				
				
				
			
			//for (var i:int = 0; i < 4; i++) {
			//	block = new RigidBody(125 + i * 250, 250+375, 0, 1, 5000, Polygon.rect(125, 125) );
			//	sandbox.addRigidBody(block);
			//}
			
			//for (var i:int = 0; i < 8; i++) {
			//	block = new RigidBody(62.5 + i * 125, 250+437.5, 0, 1, 5000, Polygon.rect(62.5, 62.5) );
			//	sandbox.addRigidBody(block);
			//}
			
			//for (var i:int = 0; i < 16; i++) {
			//	block = new RigidBody(31.25 + i * 62.5, 250+531.25-62.5, 0, 1, 5000, Polygon.rect(31.25, 31.25) );
			//	sandbox.addRigidBody(block);
			//}
			
			block = new RigidBody(333, 400, 0, 999991100000, 1100000, 0.0, 0.0, CollisionGeometry.rect(323, 20), true );
			//block.addForce(new Friction(0.1));
			sandbox.addRigidBody(block);
			
			block = new RigidBody(666, 400, 0, 999991100000, 1100000, 0.0, 0.0, CollisionGeometry.rect(323, 20), true );
			//block.addForce(new Friction(0.1));
			sandbox.addRigidBody(block);
			
			block = new RigidBody(250, 600, 0.0, 999991100000, 1100000, 0.0, 0.0, CollisionGeometry.rect(240, 20), true );
			//block.addForce(new Friction(0.1));
			sandbox.addRigidBody(block);
			block = new RigidBody(500, 600, 0.0, 999991100000, 1100000, 0.0, 0.0, CollisionGeometry.rect(240, 20), true );
			//block.addForce(new Friction(0.1));
			sandbox.addRigidBody(block);
			block = new RigidBody(750, 600, 0.0, 999991100000, 1100000, 0.0, 0.0, CollisionGeometry.rect(240, 20), true );
			//block.addForce(new Friction(0.1));
			sandbox.addRigidBody(block);
			
			block = new RigidBody(333, 800, 0, 999991100000, 1100000, 0.0, 0.0, CollisionGeometry.rect(323, 20), true );
			//block.addForce(new Friction(0.1));
			sandbox.addRigidBody(block);
			
			block = new RigidBody(666, 800, 0, 999991100000, 1100000, 0.0, 0.0, CollisionGeometry.rect(323, 20), true );
			//block.addForce(new Friction(0.1));
			sandbox.addRigidBody(block);
			
			
			
			
			
			sandbox.run();
			
			//this._rigidBody = new RigidBody(0, 0, 0, 1, 5000, CollisionGeometry.convexRegular(3, 50) );
		
			//sandbox.addRigidBody(this._rigidBody);
			//_rigidBody.addForce(new Friction(5.0));
			//_rigidBody.addForce(new Gravity(1500.0));
			
			
			
			
			
			
			//_rigidBody.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEventListener);
			//stage.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpEventListener);
			super.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		public function onEnterFrame(e:Event):void {
			for(var i:int = 0; i < _bodies.length; i++) {
				if(_bodies[i].yPosition > 1000) {
				_bodies[i].yPosition = Math.random()*100;
				_bodies[i].xPosition = 50 + Math.random()*900;
				_bodies[i].xVelocity = 0;
				_bodies[i].yVelocity = 0;
				}
				
			}
		}
		
		//private function mouseDownEventListener(event:MouseEvent):void {
			//var matrix:Matrix2D = _rigidBody.matrix;
			//
			//_mouseDownPosition.setVector(super.mouseX, super.mouseY);
			//_mouseDownPosition.subtract(_rigidBody.position);
			//_mouseDownPosition = matrix.transponseVector2D(_mouseDownPosition);
			//
			//
			//
			//super.stage.addEventListener(Event.ENTER_FRAME, this.enterFrameEventListener);
			//this._mouseDown = true;
		//}
		//private function mouseUpEventListener(event:MouseEvent):void {
			//if(_mouseDown) {
				//super.graphics.clear();
				//super.stage.removeEventListener(Event.ENTER_FRAME, this.enterFrameEventListener);
				//
				//this._mouseDown = false;
			//}
		//}
		//private function enterFrameEventListener(event:Event):void {
			//super.graphics.clear();
			//
				//var mouseUpPosition:Vector2D = new Vector2D(super.mouseX, super.mouseY);
				//this._mouseDown = false;
				//
				//var matrix:Matrix2D = _rigidBody.matrix;
				//
				//
				//var mouseDown:Vector2D = matrix.transformVector2D(_mouseDownPosition);
				//mouseDown.add(_rigidBody.positon);
			//
				//
				//var point:Vector2D = Vector2D.subtract(mouseDown, _rigidBody.positon);
				//
				//mouseUpPosition.subtract(mouseDown);
				//mouseUpPosition.subtract(_rigidBody.position);
				//
				//
				//mouseUpPosition.scale(0.5);
				//_rigidBody.addImpulseAtPoint(mouseUpPosition, mouseDown );
				//
				//
			//super.graphics.clear();
			//super.graphics.lineStyle(2.0, 0x0000FF, 0.5);
			//super.graphics.moveTo(mouseDown.x+_rigidBody.position.x, mouseDown.y+_rigidBody.position.y);
			//super.graphics.lineTo(super.mouseX, super.mouseY);
		//}
		
	}
}