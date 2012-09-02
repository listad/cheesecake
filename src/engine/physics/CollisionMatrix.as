package engine.physics {
	public class CollisionMatrix {
		public static var NULL:int = 0;
		public static var POLYGON:int = 1 << 0;
		public static var CIRCLE:int = 1 << 1;
		//1 << 2
		//1 << 3
		
		public static var POLYGON_VS_POLYGON:int = POLYGON;
		public static var POLYGON_VS_CIRCLE:int = POLYGON | CIRCLE;
		public static var CIRCLE_VS_CIRCLE:int = CIRCLE;
	}
}