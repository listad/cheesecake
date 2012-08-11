package tests {
	import engine.geometry.Matrix2D;
	import engine.geometry.Polygon;
	import engine.geometry.Vector2D;
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
			
			this._rigidBody = new RigidBody(100, 100, 0.5, 10, 10000, Polygon.convexRegular(5, 100) );
		
			sandbox.addRigidBody(this._rigidBody);
			_rigidBody.addForce(new Friction(0.5));
			
			
			//var block:RigidBody = new RigidBody(300, 300, -Math.PI * 0.05, Infinity, Infinity, Polygon.rect(300, 30) );
			//sandbox.addRigidBody(block);
			
			sandbox.run();
			
			_rigidBody.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEventListener);
			stage.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpEventListener);
			
		}
		
		private function mouseDownEventListener(event:MouseEvent):void {
			var matrix:Matrix2D = _rigidBody.matrix;
			
			_mouseDownPosition.setVector(super.mouseX, super.mouseY);
			_mouseDownPosition.subtract(_rigidBody.positon);
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
				mouseUpPosition.subtract(_rigidBody.positon);
				
				_rigidBody.addImpulseAtPoint(mouseUpPosition, mouseDown );
				
				
			super.graphics.clear();
			super.graphics.lineStyle(2.0, 0xFF0000, 0.5);
			super.graphics.moveTo(mouseDown.x+_rigidBody.positon.x, mouseDown.y+_rigidBody.positon.y);
			super.graphics.lineTo(super.mouseX, super.mouseY);
		}
		
	}
}