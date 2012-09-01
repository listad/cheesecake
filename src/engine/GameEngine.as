package engine 
{
	import engine.physics.PhysicsSolver;
	public class GameEngine 
	{
		private var _physicsSolver = new PhysicsSolver();
		private var _renderSolver = new RenderSolver();
		//rendererSolver
		//netsyncSolver
		//
		
		public function GameEngine() 
		{
			
		}
		
		public function addGameObject(gameOgject:GameObject):void {
			if (gameOgject.collider) this._colliderSolver.addCollider(gameOgject.collider);
			if (gameOgject.renderable) this._renderSolver.addRenderable(gameOgject.renderable);
			if (gameOgject.rigidBody) this._physicsSolver.addRigidbody(gameOgject.rigidBody);
		}
		
		public function step():void {
			//->
			
			this._physicsSolver.step();
			
			this._renderSolver.step();
			
			
			
			//<-
		}
		
		
		
	}

}