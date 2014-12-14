package chess 
{
	/**
	 * ...
	 * @author kaleidos
	 */
	public class AStarData 
	{

		public var value_G:uint = 0;
		public var value_H:uint = 0;
		public var parentStarData:AStarData = null;
		public var chessPt:ChessPoint = null;
		public function AStarData() 
		{
			
		}
		public function get value_F():uint
		{
			return value_G + value_H;
		}
		
	}

}