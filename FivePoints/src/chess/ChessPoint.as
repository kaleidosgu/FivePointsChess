package chess 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author kaleidos
	 */
	public class ChessPoint extends FlxSprite 
	{
		[Embed(source = "../../res/points.png")] private static var pointsChessPic:Class;
		public static var chessWidth:uint = 0;
		public static var chessHeight:uint = 0;
		private var _chosen:Boolean = false;
		private var _originalPosX:Number = 0;
		private var _originalPosY:Number = 0;
		private var _currentIndexX:uint = 0;
		private var _currentIndexY:uint = 0;
		
		private var _objectDirection:Object = new Object();
		public function ChessPoint( indexX:uint, indexY:uint, chessType:uint ) 
		{
			var posX:Number = indexX * ( chessWidth + 2 );
			var posY:Number = indexY * ( chessHeight + 2 );
			_originalPosX = posX;
			_originalPosY = posY;
			super( posX, posY, pointsChessPic );
			
			loadGraphic( pointsChessPic, true, true, chessWidth, chessHeight );
			setChessColor ( chessType );
			_currentIndexX = indexX;
			_currentIndexY = indexY;
			
			_objectDirection[ChessDefine.DIRECTION_NORTH] = null;
			_objectDirection[ChessDefine.DIRECTION_NORTH_WEST] = null;
			_objectDirection[ChessDefine.DIRECTION_NORTH_EAST] = null;
			_objectDirection[ChessDefine.DIRECTION_SOUTH_WEST] = null;
			_objectDirection[ChessDefine.DIRECTION_SOUTH_EAST] = null;
			_objectDirection[ChessDefine.DIRECTION_SOUTH] = null;
			_objectDirection[ChessDefine.DIRECTION_WEST] = null;
			_objectDirection[ChessDefine.DIRECTION_EAST] = null;
		}
		public function SetChessWithDirection( direction:uint, dirChess:ChessPoint ):void
		{
			if ( direction >= ChessDefine.DIRECTION_NORTH && direction <= ChessDefine.DIRECTION_EAST )
			{
				_objectDirection[direction]	 = dirChess;
			}
		}
		public function GetChessWithDirection( direction:uint ):ChessPoint
		{
			var findChess:ChessPoint = null;
			if ( direction >= ChessDefine.DIRECTION_NORTH && direction <= ChessDefine.DIRECTION_EAST )
			{
				findChess = _objectDirection[direction];
			}
			return findChess;
		}
		public function selfSameColorByFlag( flag:uint ):uint
		{
			var counts:uint = 0;
			if ( flag == ChessDefine.FLAG_HORIZONTAL )
			{
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_EAST, this.getChessColor() );	
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_WEST, this.getChessColor() );	
			}
			else if ( flag == ChessDefine.FLAG_VERTICAL )
			{
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_NORTH, this.getChessColor() );	
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_SOUTH, this.getChessColor() );	
			}
			else if ( flag == ChessDefine.FLAG_UPLEFT )
			{
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_NORTH_EAST, this.getChessColor() );	
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_SOUTH_WEST, this.getChessColor() );	
			}
			else if ( flag == ChessDefine.FLAG_UPRIGHT )
			{
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_NORTH_WEST, this.getChessColor() );	
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_SOUTH_EAST, this.getChessColor() );	
			}
			return counts;
		}
		private function getSameChessCountsByDirection( direction:uint, color:uint ):uint 
		{
			var counts:uint = 0;
			if ( this.isChessExist() )
			{
				if ( color == this.getChessColor() )
				{
					counts = 1;
					var findChess:ChessPoint = GetChessWithDirection( direction );
					if ( findChess != null )
					{
						counts = counts + findChess.getSameChessCountsByDirection( direction, color );
					}
				}
				else
				{
					
				}	
			}
			return counts;
		}
		public function getChessColor():uint
		{
			return this.frame;
		}
		public function setChessColor( color:uint ):void
		{
			this.frame = color;
		}
		public function chessChosen( chosen:Boolean ):void
		{
			_chosen = chosen;
			if ( _chosen == true )
			{
				this.x += 2;
				this.y += 1;
			}
			else
			{
				this.x = _originalPosX;
				this.y = _originalPosY;
			}
		}
		public function isChessExist():Boolean
		{
			return this.visible;
		}
		public function setChessExist( exist:Boolean ):void
		{
			this.visible = exist;
		}
		public function setChessDirectionChess( chessArray:Array ):void
		{
			setChessByRowIndex( _currentIndexY, chessArray );
			if ( _currentIndexY - 1 >= 0 )
			{
				setChessByRowIndex( _currentIndexY - 1, chessArray );	
			}
			if ( _currentIndexY + 1 >= 0 )
			{
				setChessByRowIndex( _currentIndexY + 1, chessArray );	
			}
		}
		private function setChessByRowIndex( rowIndex:uint, chessArray:Array ):void
		{
			if ( rowIndex >= 0 && rowIndex < chessArray.length )
			{
				var currentRow:Array = chessArray[rowIndex];
				if ( currentRow )
				{
					if ( _currentIndexX - 1 >= 0 )
					{
						setChessByColIndex( _currentIndexX - 1, ChessDefine.DIRECTION_WEST, currentRow );	
					}
					if ( _currentIndexX + 1 >= 0 )
					{
						setChessByColIndex( _currentIndexX + 1, ChessDefine.DIRECTION_EAST, currentRow );		
					}
				}	
			}
		}
		private function setChessByColIndex( colIndex:uint, direction:uint, currentRow:Array ):void
		{
			if ( colIndex >= 0 && colIndex < currentRow.length )
			{
				var westChess:ChessPoint = currentRow[colIndex];
				if ( westChess )
				{
					SetChessWithDirection( direction, westChess );	
				}
			}
		}
	}

}