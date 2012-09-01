package tests {
	import engine.physics.PhysicsSandbox;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class CoarseCollisionExperiment extends Sprite {
		private var sandbox:PhysicsSandbox;
		
		private var _bodies:Vector.<RigidBody> = new Vector.<RigidBody>();
		
		public function CoarseCollisionExperiment(stage:Stage) {
			stage.frameRate = 60;
			
			this._sandbox = new PhysicsSandbox();
			
			
			
			
			
			this._sandbox.run();
		}
		
	}
}