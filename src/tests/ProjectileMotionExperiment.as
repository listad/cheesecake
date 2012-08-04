package tests {
	import engine.geometry.Vector2D;
	import engine.physics.PhysicsSandbox;
	import engine.physics.RigidBody;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class ProjectileMotionExperiment extends Sprite {
		private var _rigidBody:RigidBody;
		private var _startTime:Number;
		public function ProjectileMotionExperiment(stage:Stage) {
			stage.frameRate = 60;
			this._startTime = new Date() .time;
			
			var sandbox:PhysicsSandbox = new PhysicsSandbox();
			super.addChild(sandbox);
			
			this._rigidBody = new RigidBody();
			sandbox.addRigidBody(this._rigidBody);
			
			//this._rigidBody.addForce(new Vector2D(10, 10));
			
			sandbox.run();
			
			super.addEventListener(Event.ENTER_FRAME, this.enterFrameEventListener);
		}
		
		private function enterFrameEventListener(event:Event):void {
			if (this._rigidBody.yPosition > 500) {
				trace( new Date().time - this._startTime );
			}
		}
	}
}