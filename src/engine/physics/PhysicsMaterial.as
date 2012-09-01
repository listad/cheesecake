package engine.physics {
	public class PhysicsMaterial {
		
		private var _friction:Number;
		private var _elasticity:Number;
		
		public function PhysicsMaterial(friction:Number = 0.25, elasticity:Number = 0.25) {
			this._friction = friction;
			this._elasticity = elasticity;
		}
		
		public function get friction():Number { return this._friction; }
		public function get elasticity():Number { return this._elasticity; }
	}
}