package engine.geometry {
	/**
	 * ...
	 * @author Listad
	 */
	public class Matrix2D {
		private var _angle:Number;
		
		private var _a:Number;
		private var _b:Number;
		private var _c:Number;
		private var _d:Number;
		
		public function Matrix2D(value:Number) {
			this.angle = value;
		}
		
		public function set angle(value:Number):void {
			this._angle = value;
			
			this._a = cos(value)
			this._b = - sin(value);
			this._c = - this._b;
			this._d = this._a;
		}
		
		public function transformVector2D(vin:Vector2D, vout:Vector2D):void {
			vout.x = this._a * vin.x + this._b * vin.y;
			vout.y = this._c * vin.x + this._d * vin.y;
		}
	}
}