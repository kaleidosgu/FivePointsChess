package chess 
{
	/**
	 * ...
	 * @author kaleidos
	 */
	public class GlobalChessStepProcessing 
	{
		
		public static var _staticIns:GlobalChessStepProcessing = null;
		private var _arrayProcessChess:Array = null;
		private var _lastChess:ChessPoint = null;
		public function GlobalChessStepProcessing() 
		{
			_arrayProcessChess = new Array();
		}
		public function removeLastChess( color:uint ):ChessPoint
		{
			var removeChess:ChessPoint = null;
			if ( _arrayProcessChess.length > 0 )
			{
				if ( _lastChess != null )
				{
					_lastChess.setChessExist( false );
				}
				var chessFind:ChessPoint = _arrayProcessChess[_arrayProcessChess.length - 1 ];
				chessFind.setChessExist( true );
				chessFind.setChessColor ( color );
				_lastChess = chessFind;
				var indexChess:uint = 0;
				removeChess = chessFind;
				for each( var chessIn:ChessPoint in _arrayProcessChess )
				{
					if ( chessIn == chessFind )
					{
						_arrayProcessChess.splice( indexChess, 1 );
						break;
					}
					indexChess++;
				}
			}
			return removeChess;
		}
		
		public static function getIns():GlobalChessStepProcessing
		{
			if ( _staticIns == null )
			{
				_staticIns = new GlobalChessStepProcessing();
			}
			return _staticIns;
		}
		public function clear():void
		{
			_arrayProcessChess.length = 0;
			_lastChess = null;
		}
		public function addChess( chess:ChessPoint ):void
		{
			_arrayProcessChess.push( chess );
		}
		
		public function get arrayProcessChess():Array 
		{
			return _arrayProcessChess;
		}
		
		public function set arrayProcessChess(value:Array):void 
		{
			_arrayProcessChess = value;
		}
	}

}