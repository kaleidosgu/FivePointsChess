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
	import chess.ToolsDefine;
	
	/**
	 * ...
	 * @author kaleidos
	 */
	public class GameStartState extends FlxState 
	{
		[Embed(source = "../../res/points.png")] private static var pointsChessPic:Class;
		[Embed(source = "../../res/back.png")] private static var bgChessPic:Class;
		[Embed(source = "../../res/cursor_new.png")] private static var cursorPic:Class;
		[Embed(source = "../../res/exchange.png")] private static var cursorExchangePic:Class;
		[Embed(source = "../../res/fireCracker.png")] private static var cursorFirePic:Class;
		[Embed(source = "../../res/bomb.png")] private static var cursorBombPic:Class;
		
		[Embed(source = "../../res/sound/pull.mp3")] private var pullSound:Class;
		[Embed(source = "../../res/sound/deny.mp3")] private var denyToolsSound:Class;
		[Embed(source = "../../res/sound/put.mp3")] private var putSound:Class;
		[Embed(source = "../../res/sound/move.mp3")] private var moveSound:Class;
		[Embed(source = "../../res/sound/getpoint.mp3")] private var getScoreSound:Class;
		[Embed(source = "../../res/sound/bomb.mp3")] private var bombSfx:Class;
		[Embed(source = "../../res/sound/firecrack.mp3")] private var fireCrackSfx:Class;
		
		
		
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
		
		public static var RANDOM_CHESS_COUNTS:uint = 3;
		
		private var _chessWidth:uint = 28;
		private var _chessHeight:uint = 28;
		private var _backGroundWidth:uint = 30;
		private var _backGroundHeight:uint = 30;
		
		private var _mouseDiffX:Number = 5;
		private var _mouseDiffY:Number = 5;
		private var _textNotify:FlxText = null;
		private var _textMoney:FlxText = null;
		private var _textGameOver:FlxText = null;
		
		private var _costCounts:uint = 0;
		private var _eachScorePerCos:uint = 10;
		private var _currentMoney:int = 1;
		private var _colLength:uint = 9;
		private var _rowLength:uint = 9;
		
		private var _currentChess:ChessPoint = null;
		
		private var _flagArray:Array = new Array();
		
		private var arrayPath:Array = new Array();
		private var _tickConstNumber:Number = 0.1;
		private var _tickNumber:Number = 0;
		
		private var _removeCounts:uint = 0;
		
		private var _gaming:Boolean = true;
		
		private var _currentToolType:uint = ToolsDefine.TOOLS_TYPE_NONE;
		
		private var _objCursorType:Object = new Object();
		
		private var previewChessArray:Array = new Array();
		private var previewCounts:uint = 3;
		
		private var tools_exchange:FlxSprite = null;
		private var tools_fireCrack:FlxSprite = null;
		private var tools_Bomb:FlxSprite = null;
		
		private var txt_tool_ex:FlxText = null;
		private var txt_tool_fc:FlxText = null;
		private var txt_tool_bb:FlxText = null;
		
		private var costExchange:uint = 1;
		private var costFirecrack:uint = 2;
		private var costBomb:uint = 3;
		
		private var costObjectContainer:Object = new Object();
		
		public function GameStartState() 
		{
			
		}

		override public function create():void
		{
			super.create();
			
			costObjectContainer[ToolsDefine.TOOLS_TYPE_EXCHANGE] = costExchange;
			costObjectContainer[ToolsDefine.TOOLS_TYPE_FIRE_CRACK] = costFirecrack;
			costObjectContainer[ToolsDefine.TOOLS_TYPE_BOMB] = costBomb;
			
			_objCursorType[ToolsDefine.TOOLS_TYPE_NONE] = cursorPic;
			_objCursorType[ToolsDefine.TOOLS_TYPE_EXCHANGE] = cursorExchangePic;
			_objCursorType[ToolsDefine.TOOLS_TYPE_FIRE_CRACK] = cursorFirePic;
			_objCursorType[ToolsDefine.TOOLS_TYPE_BOMB] = cursorBombPic;
			
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
			_textMoney = new FlxText( 130, 300, 200, "" );
			_textGameOver = new FlxText( 80, 100, 200, "Game is Over" );
			_textGameOver.size = 24;
			_textGameOver.color = 0xffff16;
			//_textGameOver.visible = false;
			add( _textNotify );
			add( _textMoney );
			
			updateCost();
			
			buildChessArray();
			
			_cursor = new FlxSprite();
			_cursor.loadGraphic( cursorPic, true, true );
			_cursor.x = FlxG.width / 2;
			_cursor.y = FlxG.height / 2;
			this.add( _cursor );
			
			//_gaming = false;
			var endBool:Boolean = false;
			buildPreviewChess();
			processPreviewChess();
			//todo
			for ( var index:uint = 0; index < 25; index++ )
			{
				putPreviewColorToChess();	
			}
			tools_exchange 	= new FlxSprite(285, 100, cursorExchangePic);
			this.add( tools_exchange );
			tools_fireCrack	= new FlxSprite(280, 150, cursorFirePic);
			this.add( tools_fireCrack );
			tools_Bomb 		= new FlxSprite(280, 200, cursorBombPic);
			this.add( tools_Bomb );
			
			txt_tool_ex = new FlxText( 275, 117, 50, "[c] x " + costExchange );
			this.add( txt_tool_ex );
			txt_tool_fc = new FlxText( 275, 172, 50, "[d] x " + costFirecrack );
			this.add( txt_tool_fc );
			txt_tool_bb = new FlxText( 275, 222, 50, "[e] x " + costBomb );
			this.add( txt_tool_bb );
			
			add( _textGameOver );
		}
		private function buildPreviewChess():void
		{
			for ( var preIndex:uint = 0; preIndex < previewCounts; preIndex++ )
			{
				var preViewChess:ChessPoint = new ChessPoint(0, 0, 0);
				this.add( preViewChess );
				preViewChess.x = 280;
				preViewChess.y = preIndex * preViewChess.height ;
				previewChessArray.push ( preViewChess ) ;
			}
		}
		public function removeFlag( flag:uint, startChess:ChessPoint ):void
		{
			var rmvCounts:uint = startChess.removeChessAndSelfByDirection( flag );
			_removeCounts = _removeCounts + rmvCounts;
			_textNotify.text = "Score is: " + _removeCounts ;
			
			FlxG.play( getScoreSound );
			
			_costCounts += rmvCounts;
			removeFlagCalcMoney();
		}
		private function removeFlagCalcMoney():void
		{
			if ( _costCounts >= _eachScorePerCos )
			{
				_costCounts -= _eachScorePerCos;
				_currentMoney++;
			}	
			updateCost();
		}
		private function useToolsCostMoney( toolsType:uint ):void
		{
			var cost:uint = costObjectContainer[toolsType];
			_currentMoney -= cost;
			updateCost();
		}
		private function updateCost():void
		{
			_textMoney.text = "Money is: " + _currentMoney;
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
			
			//_chessArray[0][0].setChessExist( true );
			/*
			_chessArray[1][1].setChessExist( true );
			_chessArray[2][1].setChessExist( true );
			_chessArray[3][1].setChessExist( true );
			_chessArray[4][1].setChessExist( true );
			_chessArray[8][1].setChessExist( true );
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
		private function putPreviewColorToChess( ):uint
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
			for each ( var previewChess:ChessPoint in previewChessArray )
			{
				var randomChess:ChessPoint = getRandomChessFromArray( findArrayChess );
				if ( randomChess )
				{
					removeChessFromArray( randomChess, findArrayChess );	
					randomChess.setChessExist( true );
					var previewChessColor:uint = previewChess.getChessColor();
					randomChess.setChessColor ( previewChessColor );
					
					var flag:int = getRemovableFlag( randomChess );
					if ( flag>= ChessDefine.FLAG_VERTICAL )
					{
						removeFlag( flag, randomChess );
					}
				}
			}
			processPreviewChess();
			return findArrayChess.length;
		}
		private function processPreviewChess():void
		{
			var colorArray:Array = random3ChessColor();
			setPreviewChessColor( colorArray );
		}
		private function random3ChessColor():Array
		{
			var arrayChessColor:Array = new Array();
			for ( var ind:uint = 0; ind < previewCounts; ind++ )
			{
				var colorChess:uint = randomChessColor();
				arrayChessColor.push( colorChess );
			}
			return arrayChessColor;
		}
		private function setPreviewChessColor( colorArray:Array ):void
		{
			var chessIndex:uint = 0;
			for each( var chessPt:ChessPoint in previewChessArray )
			{
				if ( chessIndex < colorArray.length )
				{
					var color:uint = colorArray[chessIndex] as uint;
					chessPt.setChessColor( color );
				}
				chessIndex++;
			}
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
					var needChoose:Boolean = true;
					if ( _currentToolType == ToolsDefine.TOOLS_TYPE_EXCHANGE )
					{
						needChoose = useExchangeTools( _findChess );
					}
					else if ( _currentToolType == ToolsDefine.TOOLS_TYPE_FIRE_CRACK )
					{
						needChoose = useFireCrack( _findChess );
					}
					else if ( _currentToolType == ToolsDefine.TOOLS_TYPE_BOMB )
					{
						needChoose = useBomb( _findChess );
					}
					else if( _currentToolType == ToolsDefine.TOOLS_TYPE_NONE )
					{
						if ( _currentChess )
						{
							_currentChess.chessChosen( false );	
						}
					}
					if ( needChoose )
					{
						_findChess.visible = true;
						_currentChess = _findChess;
						_currentChess.chessChosen( true );	
						FlxG.play( pullSound );
					}
				}
				else
				{
					if ( _currentChess && ( _currentToolType == ToolsDefine.TOOLS_TYPE_NONE ))
					{
						GlobalChessStepProcessing.getIns().clear();
						var res:uint = _AStarAlgLogic.AStarAlg( _currentChess, _findChess );
						var canChessMoveTo:Boolean = GlobalChessStepProcessing.getIns().arrayProcessChess.length > 1;
						initAllChessObjDirection();
						FlxG.play( putSound );
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
					var _findChess:ChessPoint = GlobalChessStepProcessing.getIns().removeLastChess(_currentChess.getChessColor());
					
					if ( _findChess && arrayLength == 1 )
					{
						_findChess.setChessColor ( _currentChess.getChessColor() );
			
						checkChessRemovable( _findChess );
					}
					FlxG.play( moveSound );
				}
				_tickNumber += FlxG.elapsed;	
			}
		}
		private function checkChessRemovable( dstChess:ChessPoint ):void
		{
			var flag:int = getRemovableFlag( dstChess );
			
			if ( flag >= ChessDefine.FLAG_VERTICAL )
			{
				removeFlag( flag, dstChess );
			}
			else
			{
				var randomRest:uint = putPreviewColorToChess();	
				if ( randomRest < RANDOM_CHESS_COUNTS )
				{
					_gaming = false;
				}
			}
			_currentChess = null;
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
					putPreviewColorToChess();
				}
			}
			else
			{
				if ( FlxG.keys.justReleased("ESCAPE"))
				{
					changeTools( ToolsDefine.TOOLS_TYPE_NONE );
				}
				else if ( FlxG.keys.justReleased("C"))
				{
					changeTools( ToolsDefine.TOOLS_TYPE_EXCHANGE );
				}
				else if ( FlxG.keys.justReleased("D"))
				{
					changeTools( ToolsDefine.TOOLS_TYPE_FIRE_CRACK );
				}
				else if ( FlxG.keys.justReleased("E"))
				{
					changeTools( ToolsDefine.TOOLS_TYPE_BOMB );
				}
				else
				{
					checkMousePress();
					replayStepProcessing();		
				}
			}
		}

		private function changeTools( type:uint ):void
		{
			var obj:Class = _objCursorType[type];
			if ( obj != null )
			{
				_cursor.loadGraphic( obj, true, true );
			}
			if ( _currentChess )
			{
				_currentChess.chessChosen( false );
				_currentChess = null;
			}
			_currentToolType = type;
		}
		private function checkCostEnoughForTools( toolsType:uint ):Boolean
		{
			var canCost:Boolean = false;
			var costTools:uint = costObjectContainer[toolsType];
			if ( _currentMoney >= costTools && costTools > 0 )
			{
				canCost = true;
			}
			else
			{
				FlxG.play(denyToolsSound);
			}
			return canCost;
		}
		private function useExchangeTools( dstChess:ChessPoint ):Boolean
		{
			var resExchange:Boolean = true;
			if ( checkCostEnoughForTools( ToolsDefine.TOOLS_TYPE_EXCHANGE ) )
			{
				if ( _currentChess )
				{
					var currColor:uint = _currentChess.getChessColor()
					var dstColor:uint = dstChess.getChessColor()
					_currentChess.setChessColor( dstColor );
					dstChess.setChessColor( currColor );
					_currentChess.chessChosen( false );
					dstChess.chessChosen( false );
					checkChessRemovable( _currentChess );
					checkChessRemovable( dstChess );
					resExchange = false;
					useToolsCostMoney( _currentToolType );
					changeTools( ToolsDefine.TOOLS_TYPE_NONE );	
				}
			}
			else
			{
				resExchange = false;
			}
			return resExchange;
		}
		private function destroyChessInArray( dstChess:ChessPoint, arrayDir:Array ):Boolean
		{
			var useRes:Boolean = false;
			var crackChessArray:Array = new Array();
			crackChessArray.push( dstChess );
			for each( var chessDir:uint in arrayDir )
			{
				crackChessArray.push( dstChess.GetChessWithDirection( chessDir ) );
			}
			var crackCounts:uint = 0;
			for each( var crackElement:ChessPoint in crackChessArray )
			{
				if ( crackElement != null )
				{
					if ( crackElement.isChessExist())
					{
						crackCounts++;
					}
					crackElement.setChessExist( false );
					crackElement.chessChosen( false );
				}
			}
			if ( crackCounts > 0 )
			{
				useRes = true;
			}
			changeTools( ToolsDefine.TOOLS_TYPE_NONE );
			return useRes;
		}
		private function useFireCrack( dstChess:ChessPoint ):Boolean
		{
			var res:Boolean = true;
			if ( checkCostEnoughForTools( ToolsDefine.TOOLS_TYPE_FIRE_CRACK ) )
			{
				var arrayDir:Array = new Array();
				arrayDir.push (ChessDefine.DIRECTION_EAST);
				arrayDir.push (ChessDefine.DIRECTION_WEST);
				res = destroyChessInArray( dstChess, arrayDir );
				FlxG.play( fireCrackSfx );
				useToolsCostMoney( _currentToolType );
				changeTools( ToolsDefine.TOOLS_TYPE_NONE );
			}
			else
			{
				res = false;
			}
			return res;
		}
		private function useBomb( dstChess:ChessPoint ):Boolean
		{
			var res:Boolean = false;
			if ( checkCostEnoughForTools( ToolsDefine.TOOLS_TYPE_BOMB ) )
			{
				var arrayDir:Array = new Array();
				arrayDir.push (ChessDefine.DIRECTION_EAST);
				arrayDir.push (ChessDefine.DIRECTION_WEST);
				arrayDir.push (ChessDefine.DIRECTION_SOUTH);
				arrayDir.push (ChessDefine.DIRECTION_NORTH);
				arrayDir.push (ChessDefine.DIRECTION_NORTH_EAST);
				arrayDir.push (ChessDefine.DIRECTION_NORTH_WEST);
				arrayDir.push (ChessDefine.DIRECTION_SOUTH_EAST);
				arrayDir.push (ChessDefine.DIRECTION_SOUTH_WEST);
				res = destroyChessInArray( dstChess, arrayDir );
				FlxG.play( bombSfx );
				useToolsCostMoney( _currentToolType );
				changeTools( ToolsDefine.TOOLS_TYPE_NONE );	
			}
			else
			{
				
			}
			return res;
		}
		override public function destroy():void
		{
			super.destroy();
		}
	}

}