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
		private var objectDirectionCanMove:Object = new Object();
		
		private var _objectDirection:Object = new Object();
		public function ChessPoint( indexX:uint, indexY:uint, chessType:uint ) 
		{
			//initObjectDirection();
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
				var chessDirection:ChessPoint = currentRow[colIndex];
				if ( chessDirection )
				{
					SetChessWithDirection( direction, chessDirection );	
				}
			}
		}
		
		public function canMoveTo( direction:uint ):Boolean
		{
			var bCanMoveTo:Boolean = false;
			var directionChess:ChessPoint = GetChessWithDirection( direction );
			if ( directionChess != null && !directionChess.isChessExist() )
			{
				bCanMoveTo = true;
			}
			return bCanMoveTo;
		}
		public function getSteps( dstChessPoint:ChessPoint ):uint
		{
			var indexX:uint = dstChessPoint._currentIndexX;
			var indexY:uint = dstChessPoint._currentIndexY;
			var stepsCounts:uint = 0;
			var mainDirection:int = getMainDirect( indexX, indexY );
			if ( mainDirection >= ChessDefine.DIRECTION_NORTH )
			{
				var canMoveChess:ChessPoint = _getCanMoveChessByDirection( mainDirection );
				if ( canMoveChess == null )
				{
					objectDirectionCanMove[mainDirection] = false;
					for ( var keyObj:Object in objectDirectionCanMove )
					{
						var keyDirection:uint = keyObj as uint;
						if ( mainDirection != keyDirection )
						{
							var canMove:Boolean = objectDirectionCanMove[keyDirection];
							if ( canMove )
							{
								var directionChess:ChessPoint = _getCanMoveChessByDirection( keyDirection );
								if ( directionChess )
								{
									trace("x = " + directionChess._currentIndexX );
									trace("y = " + directionChess._currentIndexY );
									trace("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
									trace("x = " + this._currentIndexX );
									trace("y = " + this._currentIndexY );
									trace("#####################################");
									this.x;
									objectDirectionCanMove[keyDirection] = false;
									stepsCounts = directionChess.canMoveChessContinue( keyDirection, dstChessPoint );
									if ( stepsCounts > 0 )
									{
										break;
									}
								}
								else
								{
									objectDirectionCanMove[keyDirection] = false;
								}
							}
							else
							{
								objectDirectionCanMove[keyDirection] = false;
							}	
						}
					}
				}
				else
				{
					stepsCounts = canMoveChess.canMoveChessContinue( mainDirection,dstChessPoint );	
					
					trace("x = " + canMoveChess._currentIndexX );
					trace("y = " + canMoveChess._currentIndexY );
				}
			}
			return stepsCounts;
		}
		private function _getCanMoveChessByDirection( direction:uint ):ChessPoint
		{
			var directionChess:ChessPoint = GetChessWithDirection( direction );
			var canMove:Boolean = objectDirectionCanMove[direction];
			if ( directionChess != null && !directionChess.isChessExist() && canMove )
			{
				return directionChess;
			}
			return null;
		}
		public function canMoveChessContinue( toDirection:uint, dstChessPoint:ChessPoint ):uint
		{
			var oppDirection:uint = GlobalDirection.getIns().getOppositeDirection( toDirection );
			objectDirectionCanMove[oppDirection] = false;
			var stepsCounts:uint = 0;
			if ( this == dstChessPoint )
			{
				stepsCounts = 1;
			}
			else
			{
				stepsCounts = this.getSteps( dstChessPoint );
				if ( stepsCounts > 0 )
				{
					stepsCounts++;
				}
			}
			return stepsCounts;
		}
		private function getMainDirect( indexX:int, indexY:int ):int
		{
			var indexXDiff:int = _currentIndexX - indexX;
			var indexYDiff:int = _currentIndexY - indexY;
			var indexXDiffAbs:int = indexXDiff >= 0 ? indexXDiff : 0 - indexXDiff
			var indexYDiffAbs:int = indexYDiff >= 0 ? indexYDiff : 0 - indexYDiff
			var mainDirectionX:int = getMainDirectionX( indexXDiff );
			var mainDirectionY:int = getMainDirectionY( indexYDiff );
			
			var mainDirection:int = -1;
			if ( indexXDiffAbs < indexYDiffAbs )
			{
				if ( indexXDiffAbs != 0 )
				{
					mainDirection = mainDirectionX;
				}
				else
				{
					mainDirection = mainDirectionY;
				}
			}
			else if ( indexXDiffAbs > indexYDiffAbs )
			{
				if ( indexYDiffAbs != 0 )
				{
					mainDirection = mainDirectionY;
				}
				else
				{
					mainDirection = mainDirectionX;
				}
			}
			else
			{
				mainDirection = mainDirectionY;
			}
			return mainDirection;
		}
		private function getMainDirectionX( indexXDif:int ):int
		{
			var mainDirectionX:int = -1;
			if ( indexXDif > 0 )
			{
				mainDirectionX = ChessDefine.DIRECTION_WEST;
			}
			else if ( indexXDif < 0 )
			{
				mainDirectionX = ChessDefine.DIRECTION_EAST;
			}
			return mainDirectionX;
		}
		
		private function getMainDirectionY( indexYDiff:int ):int
		{
			var mainDirectionY:int = -1;
			
			if ( indexYDiff > 0 )
			{
				mainDirectionY = ChessDefine.DIRECTION_NORTH;
			}
			else if ( indexYDiff < 0 )
			{
				mainDirectionY = ChessDefine.DIRECTION_SOUTH;
			}
			return mainDirectionY;
		}
		
		public function get originalPosX():Number 
		{
			return _originalPosX;
		}
		
		public function get originalPosY():Number 
		{
			return _originalPosY;
		}
		public function initObjectDirection():void
		{
			var northValue:Boolean = _objectDirection[ChessDefine.DIRECTION_NORTH] != null;
			var southValue:Boolean = _objectDirection[ChessDefine.DIRECTION_SOUTH] != null;
			var eastValue:Boolean = _objectDirection[ChessDefine.DIRECTION_EAST] != null;
			var westValue:Boolean = _objectDirection[ChessDefine.DIRECTION_WEST] != null;
			objectDirectionCanMove[ChessDefine.DIRECTION_EAST] = eastValue;
			objectDirectionCanMove[ChessDefine.DIRECTION_NORTH] = northValue;
			objectDirectionCanMove[ChessDefine.DIRECTION_WEST] = westValue;
			objectDirectionCanMove[ChessDefine.DIRECTION_SOUTH] = southValue;
			this;
		}
	}

}