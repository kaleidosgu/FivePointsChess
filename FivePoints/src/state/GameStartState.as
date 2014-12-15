package state 
{
	import chess.AlgAStarLogic;
	import chess.ChessPoint;
	import chess.ChessDefine;
	import chess.GlobalChessStepProcessing;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import chess.AStarData;
	import chess.AStarResult;
	
	/**
	 * ...
	 * @author kaleidos
	 */
	public class GameStartState extends FlxState 
	{
		[Embed(source = "../../res/points.png")] private static var pointsChessPic:Class;
		[Embed(source = "../../res/back.png")] private static var bgChessPic:Class;
		[Embed(source = "../../res/cursor_new.png")] private static var cursorPic:Class;
		private var _backGroundArray:Array = new Array();
		private var _chessArray:Array = new Array();
		private var _chessAllArray:Array = new Array();
		private var _cursor:FlxSprite = null;
				
		private var _AStarAlgLogic:AlgAStarLogic = new AlgAStarLogic();
		
		
		public static var ChessPointsFlag_Blue:int = 0;
		public static var ChessPointsFlag_Cayon:int = 1;
		public static var ChessPointsFlag_Green:int = 2;
		public static var ChessPointsFlag_Red:int = 3;
		public static var ChessPointsFlag_Yellow:int = 4;
		
		public var openListVector:Vector.< AStarData > = new Vector.< AStarData >;
		public var closeListVector :Vector.< AStarData > = new Vector.< AStarData >;
		
		public var arrayOpen:Array = new Array();
		public var arrayClose:Array = new Array();
		
		public static var RANDOM_CHESS_COUNTS:uint = 3;
		
		private var _chessWidth:uint = 28;
		private var _chessHeight:uint = 28;
		private var _backGroundWidth:uint = 30;
		private var _backGroundHeight:uint = 30;
		
		private var _mouseDiffX:Number = 5;
		private var _mouseDiffY:Number = 5;
		private var _textNotify:FlxText = null;
		private var _textGameOver:FlxText = null;
		
		private var _colLength:uint = 9;
		private var _rowLength:uint = 9;
		
		private var _currentChess:ChessPoint = null;
		
		private var _flagArray:Array = new Array();
		
		private var arrayPath:Array = new Array();
		private var _tickConstNumber:Number = 0.1;
		private var _tickNumber:Number = 0;
		
		private var _removeCounts:uint = 0;
		
		private var _gaming:Boolean = true;
		
		public function GameStartState() 
		{
			
		}

		override public function create():void
		{
			super.create();
			
			_flagArray.push( ChessDefine.FLAG_VERTICAL );
			_flagArray.push( ChessDefine.FLAG_HORIZONTAL );
			_flagArray.push( ChessDefine.FLAG_UPRIGHT );
			_flagArray.push( ChessDefine.FLAG_UPLEFT );

			ChessPoint.chessWidth = _chessWidth;
			ChessPoint.chessHeight = _chessHeight;
			
			for ( var bgColIndex:uint = 0; bgColIndex < _colLength; bgColIndex++ )
			{
				for ( var bgRowIndex:uint = 0; bgRowIndex < _rowLength; bgRowIndex++ )
				{
					var bgChess:FlxSprite = new FlxSprite( );
					bgChess.loadGraphic( bgChessPic, true, true, _backGroundWidth, _backGroundHeight );
					bgChess.x = bgRowIndex * _backGroundWidth;
					bgChess.y = bgColIndex * _backGroundHeight;
					this.add( bgChess );	
					var bgRect:Rectangle = new Rectangle(bgChess.x, bgChess.y, _backGroundWidth, _backGroundHeight );
					_backGroundArray.push ( bgRect );
				}
			}

			_textNotify = new FlxText( 0, 300, 200, "Score is: 0" );
			_textGameOver = new FlxText( 80, 100, 200, "Game is Over" );
			_textGameOver.size = 24;
			_textGameOver.color = 0xff0000;
			_textGameOver.visible = false;
			add( _textGameOver );
			add( _textNotify );
			
			buildChessArray();
			
			_cursor = new FlxSprite();
			_cursor.loadGraphic( cursorPic, true, true );
			_cursor.x = FlxG.width / 2;
			_cursor.y = FlxG.height / 2;
			this.add( _cursor );
			
			//todo
			random3Chesses();
			//_gaming = false;
			var endBool:Boolean = false;
		}
		public function removeFlag( flag:uint, startChess:ChessPoint ):void
		{
			var rmvCounts:uint = startChess.removeChessAndSelfByDirection( flag );
			_removeCounts = _removeCounts + rmvCounts;
			_textNotify.text = "Score is: " + _removeCounts ;
		}
		public function getRemovableFlag( findChess:ChessPoint ):int
		{
			var currentCounts:uint = 0;
			var currentFlag:int = -1;
			if ( findChess )
			{
				for each( var flag:uint in _flagArray )
				{
					var flagCounts:uint = findChess.selfSameColorByFlag( flag );
					if ( flagCounts >= ChessDefine.REMOVE_COUNTS && flagCounts > currentCounts )
					{
						currentCounts = flagCounts;
						currentFlag = flag;
					}
				}	
			}
			return currentFlag;
		}
		private function updateText( text:String ):void
		{
			_textNotify.text = _textNotify.text + text;
		}
		private function buildChessArray():void
		{
			for ( var bgRowIndex:uint = 0; bgRowIndex < _rowLength; bgRowIndex++ )
			{	
				var rowArray:Array = new Array();		
				for ( var bgColIndex:uint = 0; bgColIndex < _colLength; bgColIndex++ )
				{
					var chessPoints:ChessPoint = createChessOnIndex( bgColIndex, bgRowIndex);
					rowArray.push( chessPoints );
					_chessAllArray.push ( chessPoints );
					chessPoints.setChessExist( false );
				}
				_chessArray.push(rowArray);
			}
			
			for each( var findChess:ChessPoint in _chessAllArray )
			{
				findChess.setChessDirectionChess( _chessArray );
			}
			initAllChessObjDirection();
			//_chessArray[0][0].setChessExist( true );
			/*
			_chessArray[0][0].setChessExist( true );
			_chessArray[0][1].setChessExist( true );
			_chessArray[1][1].setChessExist( true );
			_chessArray[2][1].setChessExist( true );
			_chessArray[3][1].setChessExist( true );
			_chessArray[4][1].setChessExist( true );
			*/
			var endFun:Boolean = false;
		}
		private function findChessOnIndex( indexX:int, indexY:int ):ChessPoint
		{
			var findChess:ChessPoint = null;
			
			if ( _chessArray.length > indexY )
			{
				var _rowChessArray:Array = _chessArray[indexY];
				if ( _rowChessArray )
				{
					if ( _rowChessArray.length > indexX )
					{
						var chessPoints:ChessPoint = _rowChessArray[indexX];
						if ( chessPoints )
						{
							findChess = chessPoints;
						}
					}
				}
			}
			return findChess;
		}
		private function random3Chesses( ):uint
		{
			var findArrayChess:Array = new Array();
			for each( var findChess:ChessPoint in _chessAllArray )
			{
				if ( findChess.isChessExist() == false )
				{
					findArrayChess.push( findChess );
				}
				else
				{
				}
			}
			for ( var randomIndex:uint = 0; randomIndex < RANDOM_CHESS_COUNTS; randomIndex++ )
			{
				var randomChess:ChessPoint = getRandomChessFromArray( findArrayChess );
				if ( randomChess )
				{
					removeChessFromArray( randomChess, findArrayChess );	
					randomChess.setChessExist( true );
					var randomColor:uint = randomChessColor();
					randomChess.setChessColor ( randomColor );
				}
			}
			return findArrayChess.length;
		}
		private function randomChessColor():uint
		{
			var chessColor:int = randRange( ChessPointsFlag_Blue, ChessPointsFlag_Yellow );
			return chessColor;
		}
		private function removeChessFromArray( removeChess:ChessPoint, _array:Array ):Array 
		{
			var findIndex:int = _array.indexOf( removeChess );
			var newArray:Array = null;
			if ( findIndex >= 0 )
			{
				newArray = _array.splice( findIndex, 1 );
			}
			return newArray;
		}
		private function getRandomChessFromArray( _array:Array ):ChessPoint
		{
			var findChess:ChessPoint = null;
			var arrayLength:uint = _array.length;
			var randomInt:int = randRange( 0, arrayLength - 1 );
			findChess = _array[randomInt];
			return findChess;
		}
		private function randRange(minNum:int, maxNum:int ):int 
        {
            return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
        }
		private function createChessOnIndex( indexX:int, indexY:int ):ChessPoint
		{
			var _chessOne:ChessPoint = new ChessPoint( indexX, indexY, ChessPointsFlag_Blue );
			this.add( _chessOne );
			return _chessOne;
		}
		private function checkMousePress():void 
		{
			if ( FlxG.mouse.justReleased())
			{
				for each( var bgRect:Rectangle in _backGroundArray )
				{
					var mousePoint:Point = new Point( FlxG.mouse.x, FlxG.mouse.y );
					if ( bgRect.containsPoint( mousePoint ) )
					{
						var indexChessX:int =  mousePoint.x / _backGroundWidth;
						var indexChessY:int =  mousePoint.y / _backGroundHeight;
						mouseClickAction( indexChessX, indexChessY );	
						break;
					}
				}
			}
		}
		private function requireChessMoveTo( dstChess:ChessPoint ):Boolean
		{
			var counts:uint = 0;
			GlobalChessStepProcessing.getIns().clear();
			if ( _currentChess )
			{
				counts = _currentChess.getSteps( dstChess );
			}
			var canMoveTo:Boolean = counts > 0;
			return canMoveTo;
		}
		
		private function mouseClickAction( indexX:int, indexY:int ):void
		{
			var _findChess:ChessPoint = findChessOnIndex( indexX, indexY );
			if ( _findChess  )
			{
				if ( _findChess.isChessExist() == true )
				{
					if ( _currentChess )
					{
						_currentChess.chessChosen( false );	
					}
					_findChess.visible = true;
					_currentChess = _findChess;
					_currentChess.chessChosen( true );	
				}
				else
				{
					if ( _currentChess )
					{
						GlobalChessStepProcessing.getIns().clear();
						var res:uint = _AStarAlgLogic.AStarAlg( _currentChess, _findChess );
						if ( res == AStarResult.ASTAR_RESULT_FindPath )
						{
							//arrayPath
						}
						//var canChessMoveTo:Boolean = false;
						//canChessMoveTo = requireChessMoveTo( _findChess );
						
						var canChessMoveTo:Boolean = GlobalChessStepProcessing.getIns().arrayProcessChess.length > 1;
						initAllChessObjDirection();
						//todo
						if ( canChessMoveTo )
						{
						}
					}
					else
					{
					}
				}
			}
		}
		private function replayStepProcessing():void
		{
			var arrayLength:uint = GlobalChessStepProcessing.getIns().arrayProcessChess.length;
			if ( arrayLength > 0 )
			{
				if ( _tickNumber >= _tickConstNumber )
				{
					_tickNumber -= _tickConstNumber;
					//var _findChess:ChessPoint = GlobalChessStepProcessing.getIns().removeLastChess(_currentChess.getChessColor());
					var _findChess:ChessPoint = GlobalChessStepProcessing.getIns().removeLastChess(_currentChess.getChessColor());
					
					if ( _findChess && arrayLength == 1 )
					{
						_findChess.setChessColor ( _currentChess.getChessColor() );
			
						var flag:int = getRemovableFlag( _findChess );
						if ( flag >= ChessDefine.FLAG_VERTICAL )
						{
							removeFlag( flag, _findChess );
						}
						else
						{
							
							var randomRest:uint = random3Chesses();	
							if ( randomRest <= RANDOM_CHESS_COUNTS )
							{
								_gaming = false;
							}
							
						}
						_currentChess = null;
					}
				}
				_tickNumber += FlxG.elapsed;	
			}
		}
		private function initAllChessObjDirection():void
		{
			for each( var loopChess:ChessPoint in _chessAllArray )
			{
				loopChess.initObjectDirection();
			}
		}
		override public function update():void
		{
			super.update();
			_cursor.x = FlxG.mouse.x - _mouseDiffX;
			_cursor.y = FlxG.mouse.y - _mouseDiffY;
			if ( _gaming == false )
			{
				if(FlxG.keys.justReleased("SPACE"))
				{
					_gaming = true;
					_textGameOver.visible = false;
					buildChessArray();
					random3Chesses();
				}
			}
			else
			{
				checkMousePress();
				replayStepProcessing();	
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
	}

}