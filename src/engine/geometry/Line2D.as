package engine.geometry {
	public class Line2D {
		
		public function Line2D() {
			
		}
		
		public static function isIntersection (a1x:Number, a1y:Number, a2x:Number, a2y:Number, b1x:Number, b1y:Number, b2x:Number, b2y:Number, pIntersectPoint:Vector2D = null):Boolean {
			var de:Number = (b2y - b1y) * (a2x - a1x) - (b2x - b1x) * (a2y - a1y);
			var u0:Number = (b2x - b1x) * (a1y - b1y) - (b2y - b1y) * (a1x - b1x);
			var u1:Number = (b1x - a1x) * (a2y - a1y) - (b1y - a1y) * (a2x - a1x); 
			if(de != 0.0) {
				u0 /= de;
				u1 /= de;
				if ((u0 >= 0.0) && (u0 <= 1.0) && (u1 >= 0.0) && (u1 <= 1.0)) {
					if(pIntersectPoint != null) {
						pIntersectPoint.x = a1x + u0 * (a2x - a1x);
						pIntersectPoint.y = a1y + u0 * (a2y - a1y);
					}
					return true;
				}
			}
			return false;
		}
		
	}
}