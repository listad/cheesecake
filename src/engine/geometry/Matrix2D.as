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
		
		public function Matrix2D(value:Number = 0) {
			this.angle = value;
		}
		
		public function set angle(value:Number):void {
			this._angle = value;
			
			this._a = Math.cos(value)
			this._b = - Math.sin(value);
			this._c = - this._b;
			this._d = this._a;
		}
		
		public function toGlobal(vin:Vector2D, vout:Vector2D = null, tx:Number = 0.0, ty:Number = 0.0):Vector2D {
			if (vout == null) vout = new Vector2D();
			vout.x = tx + this._a * vin.x + this._b * vin.y;
			vout.y = ty + this._c * vin.x + this._d * vin.y;
			return vout;
		}
		
		public function toLocal(vin:Vector2D, vout:Vector2D = null, tx:Number = 0.0, ty:Number = 0.0):Vector2D {
			if (vout == null) vout = new Vector2D();
			vout.x = this._a * vin.x + this._c * vin.y - tx;
			vout.y = this._b * vin.x + this._d * vin.y - ty;
			return vout;
		}
	}
}