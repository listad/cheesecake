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
		
		public function CoarseCollisionExperiment(stage:Stage) {
			stage.frameRate = 60;
			
			var sandbox:PhysicsSandbox = new PhysicsSandbox();
			super.addChild(sandbox);
			
			var block:RigidBody;
			
			for (var i:int = 0; i < 5; i++) {
				for (var j:int = 0; j < 4; j++) {
					
				
					block = new RigidBody(160 + i * 160, 160 + j * 160, 0, 9999999999, 5000, CollisionGeometry.convexRegular(3+int(Math.random()*4), 40+40*Math.random() ) );
					sandbox.addRigidBody(block);
				}
			}
			
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
			
			
			
			
			
			this._rigidBody = new RigidBody(0, 0, 0, 1, 5000, CollisionGeometry.convexRegular(3, 50) );
		
			sandbox.addRigidBody(this._rigidBody);
			_rigidBody.addForce(new Friction(10.0));
			//_rigidBody.addForce(new Gravity(1500.0));
			
			
			
			
			sandbox.run();
			
			_rigidBody.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEventListener);
			stage.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpEventListener);
			
		}
		
		private function mouseDownEventListener(event:MouseEvent):void {
			var matrix:Matrix2D = _rigidBody.matrix;
			
			_mouseDownPosition.setVector(super.mouseX, super.mouseY);
			_mouseDownPosition.subtract(_rigidBody.position);
			_mouseDownPosition = matrix.transponseVector2D(_mouseDownPosition);
			
			
			
			super.stage.addEventListener(Event.ENTER_FRAME, this.enterFrameEventListener);
			this._mouseDown = true;
		}
		private function mouseUpEventListener(event:MouseEvent):void {
			if(_mouseDown) {
				super.graphics.clear();
				super.stage.removeEventListener(Event.ENTER_FRAME, this.enterFrameEventListener);
				
				this._mouseDown = false;
			}
		}
		private function enterFrameEventListener(event:Event):void {
			super.graphics.clear();
			
				var mouseUpPosition:Vector2D = new Vector2D(super.mouseX, super.mouseY);
				//this._mouseDown = false;
				
				var matrix:Matrix2D = _rigidBody.matrix;
				
				
				var mouseDown:Vector2D = matrix.transformVector2D(_mouseDownPosition);
				//mouseDown.add(_rigidBody.positon);
			
				
				//var point:Vector2D = Vector2D.subtract(mouseDown, _rigidBody.positon);
				
				mouseUpPosition.subtract(mouseDown);
				mouseUpPosition.subtract(_rigidBody.position);
				
				
				mouseUpPosition.scale(0.5);
				_rigidBody.addImpulseAtPoint(mouseUpPosition, mouseDown );
				
				
			//super.graphics.clear();
			//super.graphics.lineStyle(2.0, 0x0000FF, 0.5);
			//super.graphics.moveTo(mouseDown.x+_rigidBody.position.x, mouseDown.y+_rigidBody.position.y);
			//super.graphics.lineTo(super.mouseX, super.mouseY);
		}
		
	}
}