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
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_EAST, this );	
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_WEST, this );	
			}
			else if ( flag == ChessDefine.FLAG_VERTICAL )
			{
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_NORTH, this );	
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_SOUTH, this );	
			}
			else if ( flag == ChessDefine.FLAG_UPRIGHT )
			{
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_NORTH_EAST, this );	
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_SOUTH_WEST, this );	
			}
			else if ( flag == ChessDefine.FLAG_UPLEFT )
			{
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_NORTH_WEST, this );	
				counts = counts + getSameChessCountsByDirection( ChessDefine.DIRECTION_SOUTH_EAST, this );	
			}
			counts = counts + 1;
			return counts;
		}
		public function removeChessAndSelfByDirection( flag:uint ):uint
		{
			var direction1:uint = 0;
			var direction2:uint = 0;
			switch( flag )
			{
				case ChessDefine.FLAG_VERTICAL:
					{
						direction1 = ChessDefine.DIRECTION_NORTH;
						direction2 = ChessDefine.DIRECTION_SOUTH;
					}
					break;
				case ChessDefine.FLAG_HORIZONTAL:
					{
						direction1 = ChessDefine.DIRECTION_EAST;
						direction2 = ChessDefine.DIRECTION_WEST;
					}
					break;
				case ChessDefine.FLAG_UPRIGHT:
					{
						direction1 = ChessDefine.DIRECTION_NORTH_EAST;
						direction2 = ChessDefine.DIRECTION_SOUTH_WEST;
					}
					break;
				case ChessDefine.FLAG_UPLEFT:
					{
						direction1 = ChessDefine.DIRECTION_NORTH_WEST;
						direction2 = ChessDefine.DIRECTION_SOUTH_EAST;
					}
					break;
				default:
					{
						
					}
					break;
			}
			var counts:uint = this.removeChessByDirection( direction1, this ) ;
			counts = counts + this.removeChessByDirection( direction2, this ) ;
			counts = counts + 1;
			this.setChessExist( false );
			return counts;
		}
		private function removeChessByDirection( direction:uint, sourceChess:ChessPoint ):uint 
		{
			var counts:uint = 0;
			if ( this.isChessExist() )
			{
				if ( sourceChess == this )
				{
					
				}
				else
				{
					this.setChessExist( false );
					counts = 1;	
				}
				
				var findChess:ChessPoint = GetChessWithDirection( direction );
				if ( findChess != null )
				{
					if ( findChess.getChessColor() == this.getChessColor() )
					{
						counts = counts + findChess.removeChessByDirection( direction,sourceChess );
					}
				}
			}
			return counts;
		}
		private function getSameChessCountsByDirection( direction:uint, sourceChess:ChessPoint ):uint 
		{
			var counts:uint = 0;
			if ( this.isChessExist() )
			{
				if ( sourceChess.getChessColor() == this.getChessColor() )
				{
					if ( sourceChess != this )
					{
						counts = 1;
					}
					var findChess:ChessPoint = GetChessWithDirection( direction );
					if ( findChess != null )
					{
						counts = counts + findChess.getSameChessCountsByDirection( direction, sourceChess );
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
			setChessByRowIndex( chessArray );
		}
		private function setUpObject( rowArray:Array, UP:Boolean ):void
		{
			if ( UP )
			{
				setChessByColIndex( _currentIndexX , ChessDefine.DIRECTION_NORTH, rowArray );
				setChessByColIndex( _currentIndexX - 1, ChessDefine.DIRECTION_NORTH_WEST, rowArray );
				setChessByColIndex( _currentIndexX + 1, ChessDefine.DIRECTION_NORTH_EAST, rowArray );	
			}
			else
			{
				setChessByColIndex( _currentIndexX , ChessDefine.DIRECTION_SOUTH, rowArray );
				setChessByColIndex( _currentIndexX - 1, ChessDefine.DIRECTION_SOUTH_WEST, rowArray );
				setChessByColIndex( _currentIndexX + 1, ChessDefine.DIRECTION_SOUTH_EAST, rowArray );	
			}
		}
		private function setChessByRowIndex( chessArray:Array ):void
		{
			var currentRow:Array = null;
			var upRow:Array = null;
			var downRow:Array = null;
			if ( _currentIndexY >= 0 && _currentIndexY < chessArray.length )
			{
				currentRow = chessArray[_currentIndexY];
			}
			if ( _currentIndexY - 1 >= 0 && _currentIndexY - 1 < chessArray.length )
			{
				upRow = chessArray[_currentIndexY - 1];
			}
			if ( _currentIndexY + 1 >= 0 && _currentIndexY + 1 < chessArray.length )
			{
				downRow = chessArray[_currentIndexY + 1];
			}
			if ( currentRow )
			{
				setChessByColIndex( _currentIndexX - 1, ChessDefine.DIRECTION_WEST, currentRow );	
				setChessByColIndex( _currentIndexX + 1, ChessDefine.DIRECTION_EAST, currentRow );
			}
			if ( upRow )
			{
				setChessByColIndex( _currentIndexX , ChessDefine.DIRECTION_NORTH, upRow );	
				setChessByColIndex( _currentIndexX + 1, ChessDefine.DIRECTION_NORTH_EAST, upRow );
				setChessByColIndex( _currentIndexX - 1, ChessDefine.DIRECTION_NORTH_WEST, upRow );
			}
			if ( downRow )
			{
				setChessByColIndex( _currentIndexX , ChessDefine.DIRECTION_SOUTH, downRow );	
				setChessByColIndex( _currentIndexX + 1, ChessDefine.DIRECTION_SOUTH_EAST, downRow );
				setChessByColIndex( _currentIndexX - 1, ChessDefine.DIRECTION_SOUTH_WEST, downRow );
			}
		}
		private function setChessByColIndex( colIndex:int , direction:uint, currentRow:Array ):void
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