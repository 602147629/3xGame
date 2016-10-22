package framework.ui
{
	import com.game.module.CDataManager;
	import com.game.module.CDataOfLevel;
	import com.games.candycrush.board.Board;
	import com.games.candycrush.board.match.OrthoPatternMatcher;
	
	import flash.display.MovieClip;
	
	import framework.datagram.Datagram;
	import framework.model.ConstantItem;
	import framework.model.objects.BasicObject;
	import framework.model.objects.GridObject;
	import framework.model.objects.LevelData;
	import framework.resource.faxb.levelproperty.Color;
	import framework.resource.faxb.levels.Basic;
	import framework.resource.faxb.levels.Level;
	import framework.util.ResHandler;
	import framework.view.mediator.MediatorBase;
	import framework.view.mediator.MediatorExBase;
	
	public class MediatorExMainUI extends MediatorExBase
	{
		private static const LINE_OFFSET:int = 12;
		private static const ROUND_OFFSET:int = 12;
		public function MediatorExMainUI(mediatorBase:MediatorBase)
		{
			super(mediatorBase);
		}
		
		private var _mainUI:MediatorPanelMainUI;
		override public function start(data:Datagram):void
		{
			_mainUI = getParent() as MediatorPanelMainUI;
			drawGridBg();
		}
		
		public function getRandomBasic(basicData:Basic, board:Board, match:OrthoPatternMatcher, gridX:int, gridY:int):BasicObject
		{
			//get a random color
			var colors:Vector.<Color> = CDataManager.getInstance().dataOfLevel.limitColors();
			var length:int = colors.length;
			var indexs:Vector.<int> = new Vector.<int>();
			var basicObject:BasicObject = null;
			while(true)
			{
				if(indexs.length == length)
				{
					ASSERT(false, "can not find right color!");
				}
				var index:int = int(Math.random() * length);
				if(indexs.indexOf(index) < 0)
				{
					indexs.push(index);
					var color:int = colors[index].id;
					//check match
					//push color
					board._mInt[gridY][gridX] = color;
					//testIsOk
					if(!board.testColorIsMatch(gridX, gridY, match))
					{
						if(basicData.id == ConstantItem.GRID_ID_RANDOM_NORMAL)
						{
							basicObject = new BasicObject(color);
						}
						else if(basicData.id == ConstantItem.GRID_ID_RANDOM_VARIABLE)
						{
							basicObject = new BasicObject(ConstantItem.VARIABLE_OBJECT_START_INDEX + color);
						}
						else if(basicData.id == ConstantItem.GRID_ID_RANDOM_CLOCK)
						{
							basicObject = new BasicObject(ConstantItem.CLOCK_START_INDEX + color);
						}
						else if(basicData.id == ConstantItem.GRID_ID_RANDOM_JELLY)
						{
							basicObject = new BasicObject(ConstantItem.JELLY_START_INDEX + color);
						}
						else if(basicData.id == ConstantItem.GRID_ID_RANDOM_GIFT)
						{
							basicObject = new BasicObject(ConstantItem.GIFT_START_INDEX + color);
						}
						break;
					}
				}					
			}
			
			return basicObject;
		}
		
		private function drawLine(x:int, y:int , width:int, mcBg:MovieClip):void
		{
			var bgline:MovieClip = ResHandler.getMcFirstLoad("bgLine1pixel");
			bgline.scaleX = width;
			mcBg.addChild(bgline);
			
			bgline.x = x;
			bgline.y = y;
		}
		
		private function drawColumn(x:int, y:int , width:int, mcBg:MovieClip):void
		{
			var bgColune:MovieClip = ResHandler.getMcFirstLoad("bgColumn1pixel");
			bgColune.scaleY = width;
			mcBg.addChild(bgColune);
			
			bgColune.x = x;
			bgColune.y = y;
		}
		
		private function drawLeftTopRound(x:int, y:int, mcBg:MovieClip):void
		{
			var bgColune:MovieClip = ResHandler.getMcFirstLoad("bgLeftUp");
			mcBg.addChild(bgColune);
			
			bgColune.x = x;
			bgColune.y = y;
			
		}
		
		private function drawRightTopRound(x:int, y:int, mcBg:MovieClip):void
		{
			var bgColune:MovieClip = ResHandler.getMcFirstLoad("bgRightUp");
			mcBg.addChild(bgColune);
			
			bgColune.x = x ;
			bgColune.y = y;			
		}
		
		private function drawRightDownRound(x:int, y:int, mcBg:MovieClip):void
		{
			var bgColune:MovieClip = ResHandler.getMcFirstLoad("bgRightDown");
			mcBg.addChild(bgColune);
			
			bgColune.x = x ;
			bgColune.y = y;
			
		}
		
		private function drawLeftDownRound(x:int, y:int, mcBg:MovieClip):void
		{
			var bgColune:MovieClip = ResHandler.getMcFirstLoad("bgLeftDown");
			mcBg.addChild(bgColune);
			
			bgColune.x = x ;
			bgColune.y = y;
			
		}
		
		private function drawGridBg():void
		{
			var levelData:LevelData =  _mainUI.currentLevelData;
			var mcbg:MovieClip = mc["mcGrid"]["mcBgLayer"];
			//todo draw eage line
			
			var GRID_W:int = MediatorPanelMainUI.GRID_WIDHT;
	/*		drawLine(0,0, MediatorPanelMainUI.GRID_WIDHT * MediatorPanelMainUI.MAX_LINE_NUMBER, mcbg); 
			drawColumn(0,0, MediatorPanelMainUI.GRID_WIDHT * 8, mcbg); 
			drawColumn(MediatorPanelMainUI.GRID_WIDHT * MediatorPanelMainUI.MAX_LINE_NUMBER + LINE_OFFSET, 0, MediatorPanelMainUI.GRID_WIDHT * 8, mcbg);
			drawLine(0, MediatorPanelMainUI.GRID_WIDHT * 8 + LINE_OFFSET,  MediatorPanelMainUI.GRID_WIDHT * MediatorPanelMainUI.MAX_LINE_NUMBER, mcbg);*/
			
			
			mcbg.graphics.beginFill(0, 0.4);
			mcbg.graphics.drawRect(0,0, MediatorPanelMainUI.GRID_WIDHT * MediatorPanelMainUI.MAX_LINE_NUMBER, MediatorPanelMainUI.GRID_WIDHT * MediatorPanelMainUI.MAX_LINE_NUMBER);
			
			for(var i:int = 0; i < MediatorPanelMainUI.MAX_LINE_NUMBER; i++)
			{
				for(var j:int = 0; j < MediatorPanelMainUI.MAX_LINE_NUMBER; j++)
				{
					var grid:GridObject = levelData.getGrid(i, j);
					
				
					if(grid.isHideGrid())
					{
						mcbg.graphics.drawRect( i * GRID_W, j * GRID_W, GRID_W, GRID_W);
					}
					else
					{
						var leftGrid:GridObject = levelData.getGrid(i-1, j);
						var topGrid:GridObject = levelData.getGrid(i, j-1);
						var rightGrid:GridObject = levelData.getGrid(i+1, j);
						var downGrid:GridObject = levelData.getGrid(i, j+1);
						
						var leftDownGrid:GridObject = levelData.getGrid(i-1, j+1);
						var rightDownGrid:GridObject = levelData.getGrid(i+1, j+1);
						var leftTopGrid:GridObject = levelData.getGrid(i-1, j-1);
						var rightTopGrid:GridObject = levelData.getGrid(i+1, j-1);
						
						var isLeft:Boolean = false;
						var isTop:Boolean = false;
						var isRight:Boolean = false;
						var isDown:Boolean = false;
						var leftDraw:DrawLineObject = new DrawLineObject(i * GRID_W , j * GRID_W, GRID_W);
						var rightDraw:DrawLineObject = new DrawLineObject((i+1) * GRID_W + LINE_OFFSET, j * GRID_W, GRID_W);
						var topDraw:DrawLineObject = new DrawLineObject(i * GRID_W , j * GRID_W, GRID_W);
						var downDraw:DrawLineObject = new DrawLineObject(i * GRID_W , (j+1) * GRID_W + LINE_OFFSET, GRID_W);
						
						
						if(leftGrid == null || leftGrid.isHideGrid())
						{
							isLeft = true;												
						}
						if(rightGrid == null || rightGrid.isHideGrid())
						{
							isRight = true;
						}
						if(topGrid == null || topGrid.isHideGrid())
						{
							isTop = true;
						}
						if(downGrid == null || downGrid.isHideGrid())
						{
							isDown = true;
						}
						
						var isDrawLeftTopOut:Boolean = false;
						var isDrawLeftTopIn:Boolean = false;
						var isDrawLeftDownOut:Boolean = false;
						var isDrawLeftDownIn:Boolean = false;
						var isDrawRightTopOut:Boolean = false;
						var isDrawRightTopIn:Boolean = false;
						var isDrawRightDownOut:Boolean = false;
						var isDrawRightDownIn:Boolean = false;
						
						if(isLeft && isTop)
						{
							if(leftTopGrid != null && !leftTopGrid.isHideGrid())
							{
								
							}
							else
							{							
								drawLeftTopRound(i * GRID_W, j* GRID_W, mcbg);
								isDrawLeftTopOut = true;
							}
							
							leftDraw.startY += ROUND_OFFSET;
							leftDraw.length -= ROUND_OFFSET;
							topDraw.startX += ROUND_OFFSET;
//							topDraw.length -= ROUND_OFFSET;
							topDraw.deleteLength(ROUND_OFFSET);
						
						}
						
						if(isRight && isTop)
						{
							if(rightTopGrid != null && ! rightTopGrid.isHideGrid())
							{
								
							}
							else
							{								
								drawRightTopRound((i+1) * GRID_W, j* GRID_W, mcbg);
								isDrawRightTopOut = true;
							}
							
							rightDraw.startY += ROUND_OFFSET;
							rightDraw.length -= ROUND_OFFSET;

							topDraw.deleteLength(ROUND_OFFSET);
						}
						
						if(isLeft && isDown)
						{
							if(leftDownGrid != null && !leftDownGrid.isHideGrid())
							{
								
							}
							else
							{
								
								drawLeftDownRound(i * GRID_W, (j+1)* GRID_W, mcbg);
								isDrawLeftDownOut = true;
							}
							
//							leftDraw.startY += ROUND_OFFSET;
							//todo not inflution current left							
//							leftDraw.length -= ROUND_OFFSET;
							
							/*downDraw.startX += ROUND_OFFSET;
							downDraw.length -= ROUND_OFFSET;*/
						}
						
						if(isRight && isDown)
						{
							if(rightDownGrid != null && !rightDownGrid.isHideGrid())
							{
								
							}
							else
							{								
								drawRightDownRound((i+1) * GRID_W, (j+1)* GRID_W, mcbg);
								isDrawRightDownOut = true;
							}
							
//							rightDraw.startY += ROUND_OFFSET;
							
							//todo not inflution down ground
//							rightDraw.length -= ROUND_OFFSET;
							/*if(isLeft)
							{								
								downDraw.length -= ROUND_OFFSET;
							}*/
						}
						
						if(isLeft && leftDownGrid != null && !leftDownGrid.isHideGrid())
						{
							drawRightDownRound((i) * GRID_W - LINE_OFFSET, (j+1)* GRID_W - LINE_OFFSET, mcbg);
							isDrawRightDownIn = true;
							
							leftDraw.length -= ROUND_OFFSET*2;
						}
						
						if(isRight && rightDownGrid != null && ! rightDownGrid.isHideGrid())
						{
							drawLeftDownRound((i+1) * GRID_W + LINE_OFFSET, (j+1)* GRID_W - LINE_OFFSET, mcbg);
							isDrawLeftDownIn = true;
							
							rightDraw.length -= ROUND_OFFSET*2;
						}
						
						if(isDown && leftDownGrid != null && !leftDownGrid.isHideGrid())
						{
							drawLeftTopRound( i * GRID_W + LINE_OFFSET, (j + 1)*GRID_W + LINE_OFFSET, mcbg);
							isDrawLeftTopIn = true;
							//todo isRight
							/*downDraw.startX += ROUND_OFFSET;
							downDraw.length -= ROUND_OFFSET;*/				
						}
						
						if(isDown && rightDownGrid != null && !rightDownGrid.isHideGrid())
						{
							drawRightTopRound( (i+1) * GRID_W - LINE_OFFSET, (j + 1)*GRID_W + LINE_OFFSET, mcbg);
							isDrawRightTopIn = true;
//							topDraw.length -= ROUND_OFFSET;
							//todo rightdown not inflution top 
//							topDraw.deleteLength(ROUND_OFFSET);
							if(!(isRight))
							{								
								rightDraw.startY += ROUND_OFFSET;
								rightDraw.length -= ROUND_OFFSET;
							}
							
							/*if(leftDownGrid != null && !leftDownGrid.isHideGrid())
							{
								downDraw.length -= ROUND_OFFSET;
							}
							else
							{
								
								downDraw.length -= ROUND_OFFSET*2;
							}*/
						}
						
						if(isTop && rightTopGrid != null && !rightTopGrid.isHideGrid())
						{
							/*if(isDown && ((rightDownGrid != null && !rightDownGrid.isHideGrid())))
							{
								topDraw.deleteLength(ROUND_OFFSET);
				
							}
							else */
							if(isRight && !isLeft)
							{
								topDraw.deleteLength(ROUND_OFFSET);
							}
							else
							{														
								topDraw.deleteLength(ROUND_OFFSET);
								topDraw.deleteLength(ROUND_OFFSET);
							}
							
						}
						
						if(isTop && leftTopGrid != null && !leftTopGrid.isHideGrid())
						{
							//todo leftTop
							topDraw.startX += ROUND_OFFSET;
							topDraw.deleteLength(ROUND_OFFSET);
						
						}
						
						if(isDrawLeftTopIn)
						{
							downDraw.startX += ROUND_OFFSET;
							downDraw.length -= ROUND_OFFSET;
							downDraw.startX += ROUND_OFFSET;
							downDraw.length -= ROUND_OFFSET;
						}									
						else if(isDrawLeftDownOut)
						{
							downDraw.startX += ROUND_OFFSET;
							downDraw.length -= ROUND_OFFSET;
							
							if(isDrawLeftTopOut)
							{
								leftDraw.length -= ROUND_OFFSET;
							}
						}
						
						if(isDrawRightTopIn)
						{
							downDraw.length -= ROUND_OFFSET;
							downDraw.length -= ROUND_OFFSET;
						}
						if(isDrawRightDownOut)
						{
							downDraw.length -= ROUND_OFFSET;
						}
						
						if(isDrawRightTopOut && isDrawRightDownOut)
						{
							rightDraw.length -= ROUND_OFFSET;
						}
						
						if(isLeft)
						{
							if(leftTopGrid != null && !leftTopGrid.isHideGrid())
							{
								if(isTop)
								{
									leftDraw.startY += ROUND_OFFSET;
									leftDraw.length -= ROUND_OFFSET;
								}
								else
								{
									leftDraw.startY += ROUND_OFFSET*2;
									leftDraw.length -= ROUND_OFFSET*2;
								}
								
							}
								
							drawColumn(leftDraw.startX , leftDraw.startY, leftDraw.length, mcbg); 
							
						}
						if(isRight)
						{
							if(rightTopGrid != null && !rightTopGrid.isHideGrid())
							{
								if(isTop)
								{
									rightDraw.startY += ROUND_OFFSET;
									rightDraw.length -= ROUND_OFFSET;
								}
								else
								{
									rightDraw.startY += ROUND_OFFSET*2;
									rightDraw.length -= ROUND_OFFSET*2;
								}
								
							}
							
							drawColumn(rightDraw.startX, rightDraw.startY, rightDraw.length, mcbg); 
						}
						if(isTop)
						{
							drawLine(topDraw.startX , topDraw.startY, topDraw.length, mcbg);
						}
						if(isDown)
						{
							
							drawLine(downDraw.startX , downDraw.startY, downDraw.length, mcbg);
						}
					}
				}
				
			}
			
			mcbg.graphics.endFill();
					
		}
	}
}

class DrawLineObject
{
	public var startX:int;
	public var startY:int;
	private var _length:int;
	private var maxLength:int;
	public function DrawLineObject(x:int, y:int, width:int)
	{
		startX = x;
		startY = y;
		_length = width;
		maxLength = 3;
	}
	
	public function deleteLength(width:int):void
	{
		if(isCanClean())
		{
			_length -= width;
				
			--maxLength;
		}
	}
		
	
	public function isCanClean():Boolean
	{
		return maxLength > 0;
	}

	public function get length():int
	{
		return _length;
	}

	public function set length(value:int):void
	{
		_length = value;
	}
	
	
}