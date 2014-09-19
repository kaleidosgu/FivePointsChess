package chess 
{
	/**
	 * ...
	 * @author kaleidos
	 */
	public class GlobalDirection 
	{
		public var _objOppositeDirection:Object = new Object();
		public static var _staticIns:GlobalDirection = null;
		public function GlobalDirection() 
		{
			_objOppositeDirection[ChessDefine.DIRECTION_EAST] = ChessDefine.DIRECTION_WEST;
			_objOppositeDirection[ChessDefine.DIRECTION_SOUTH] = ChessDefine.DIRECTION_NORTH;
			_objOppositeDirection[ChessDefine.DIRECTION_WEST] = ChessDefine.DIRECTION_EAST;
			_objOppositeDirection[ChessDefine.DIRECTION_NORTH] = ChessDefine.DIRECTION_SOUTH;
			
			_objOppositeDirection[ChessDefine.DIRECTION_SOUTH_WEST] = ChessDefine.DIRECTION_NORTH_EAST;
			_objOppositeDirection[ChessDefine.DIRECTION_NORTH_EAST] = ChessDefine.DIRECTION_SOUTH_WEST;
			_objOppositeDirection[ChessDefine.DIRECTION_NORTH_WEST] = ChessDefine.DIRECTION_SOUTH_EAST;
			_objOppositeDirection[ChessDefine.DIRECTION_SOUTH_EAST] = ChessDefine.DIRECTION_NORTH_WEST;
		}
		public static function getIns():GlobalDirection
		{
			if ( _staticIns == null )
			{
				_staticIns = new GlobalDirection();
			}
			return _staticIns;
		}
		public function getOppositeDirection( direction:uint ):uint
		{
			return _objOppositeDirection[direction];
		}
		
	}

}