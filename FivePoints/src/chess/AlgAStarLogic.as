package chess 
{
	import chess.ChessPoint;
	/**
	 * ...
	 * @author kaleidos
	 */
	public class AlgAStarLogic 
	{
		
		private var arrayOpen:Array = new Array();
		private var arrayClose:Array = new Array();
		private var arrayPath:Array = new Array();
		private var G_VALUE_CHESS:uint = 10;
		public function AlgAStarLogic() 
		{
			
		}
		public function AStarAlg( currentChessPt:ChessPoint, targetChessPt:ChessPoint ):uint
		{
			arrayOpen.length = 0;
			arrayClose.length = 0;
			arrayPath.length = 0;
			var startStart:AStarData = new AStarData();
			startStart.chessPt = currentChessPt;
			//openListVector.push( startStart );
			arrayOpen.push ( startStart );
			var res:uint = AStarResult.ASTAR_RESULT_Continue;
			
			while ( ( res = AStarRepeat( targetChessPt) ) == AStarResult.ASTAR_RESULT_Continue )
			{
			}
			return res;
		}
		
		private function AStarRepeat( targetChess:ChessPoint ):uint
		{
			var resRepeat:uint = AStarResult.ASTAR_RESULT_Continue;
			var currentStarData:AStarData = findLeastAStarData();
			if ( currentStarData )
			{
				if ( targetChess == currentStarData.chessPt )
				{
					resRepeat = AStarResult.ASTAR_RESULT_FindPath;
				}
				else
				{
					switchChessToCloseList( currentStarData );
					nearChessProcess( currentStarData, targetChess );
				}
			}
			else
			{
				resRepeat = AStarResult.ASTAR_RESULT_NoPath;
			}
			return resRepeat;
		}
		private function findLeastAStarData():AStarData
		{
			var vec:Vector.< AStarData > = new Vector.< AStarData >;
			for each( var openElement:AStarData in arrayOpen )
			{
				vec.push( openElement );
			}
			vec.sort( sortFunc );
			var find:AStarData = null;
			if ( vec.length > 0 )
			{
				find = vec[0];
			}
			return find;
		}
		private function switchChessToCloseList( starData:AStarData ):void
		{
			arrayClose.push ( starData );
			var index:int = arrayOpen.indexOf( starData );
			if ( index >= 0 )
			{
				arrayOpen.splice( index, 1 );
			}
		}
		private function nearChessProcess( starData:AStarData, targetChessPt:ChessPoint ):AStarData
		{
			var newCurrentData:AStarData = null;
			var currentChess:ChessPoint = starData.chessPt
			if ( currentChess )
			{
				var eastChess:ChessPoint = currentChess.GetChessWithDirection( ChessDefine.DIRECTION_EAST );
				var northChess:ChessPoint = currentChess.GetChessWithDirection( ChessDefine.DIRECTION_NORTH );
				var southChess:ChessPoint = currentChess.GetChessWithDirection( ChessDefine.DIRECTION_SOUTH );
				var westChess:ChessPoint = currentChess.GetChessWithDirection( ChessDefine.DIRECTION_WEST );
				
				var eastGValue:AStarData = eachNearChessProcess( eastChess, starData, targetChessPt );
				var northGValue:AStarData = eachNearChessProcess( northChess, starData, targetChessPt );
				var southGValue:AStarData = eachNearChessProcess( southChess, starData, targetChessPt );
				var westGValue:AStarData = eachNearChessProcess( westChess, starData, targetChessPt );
				
				var vec:Vector.<AStarData> = new Vector.<AStarData>();
				if ( eastGValue != null )
				{
					vec.push( eastGValue );
				}
				if ( northGValue != null )
				{
					vec.push( northGValue );
				}
				if ( southGValue != null )
				{
					vec.push( southGValue );
				}
				if ( westGValue != null )
				{
					vec.push( westGValue );
				}
				
				vec.sort( sortFunc );
				if ( vec )
				{
					if ( vec.length > 0 )
					{
						var foundStar:AStarData = vec[0];
						newCurrentData = foundStar.parentStarData;
						//arrayPath.push( foundStar );
						GlobalChessStepProcessing.getIns().addChess( foundStar.chessPt );
					}
				}
			}
			return newCurrentData;
		}
		
		private function sortFunc( data1:AStarData, data2:AStarData ):int
		{
			if ( data1.value_F < data2.value_F )
			{
				return -1;
			}
			else if ( data1.value_F == data2.value_F )
			{
				return 0;
			}
			else
			{
				return 1;
			}
		}
		private function eachNearChessProcess( chessPt:ChessPoint, currentStarData:AStarData, targetChessPt:ChessPoint ):AStarData
		{
			var astrReturn:AStarData = null;
			if ( chessPt )
			{
				if ( chessPt.isChessExist() )
				{
					//ignore it 
				}
				else
				{
					var foundInClose:AStarData = findAStarDataInListByChessPt( chessPt, arrayClose );
					if ( foundInClose != null )
					{
						//ignore it 
					}
					else
					{
						var foundInOpen:AStarData = findAStarDataInListByChessPt( chessPt, arrayOpen );
						if ( foundInOpen != null )
						{
							astrReturn = foundInOpen;
							astrReturn.parentStarData.value_G = 0;
							astrReturn.value_G = G_VALUE_CHESS + astrReturn.parentStarData.value_G;
						}
						else
						{
							var newData:AStarData = new AStarData();
							newData.chessPt = chessPt;
							newData.parentStarData = currentStarData;
							newData.value_G = currentStarData.value_G + G_VALUE_CHESS;
							newData.value_H = caclHValue( chessPt, targetChessPt );
							arrayOpen.push ( newData );
						}
					}
				}
			}
			else 
			{
			}
			return astrReturn;
		}
		private function caclHValue( currentChess:ChessPoint, targetChess:ChessPoint ):uint
		{
			var HValue:uint = 0;
			if ( currentChess.currentIndexX >= targetChess.currentIndexX )
			{
				HValue += currentChess.currentIndexX - targetChess.currentIndexX;
			}
			else
			{
				HValue += targetChess.currentIndexX - currentChess.currentIndexX;
			}
			
			if ( currentChess.currentIndexY >= targetChess.currentIndexY )
			{
				HValue += currentChess.currentIndexY - targetChess.currentIndexY;
			}
			else
			{
				HValue += targetChess.currentIndexY - currentChess.currentIndexY;
			}
			return HValue + 1;
		}
		private function findAStarDataInListByChessPt( chessFind:ChessPoint, listArray:Array ):AStarData
		{
			var res:AStarData = null;
			for each( var starData:AStarData in listArray )
			{
				if ( starData.chessPt == chessFind )
				{
					res = starData;
					break;
				}
			}
			return res;
		}
	}

}