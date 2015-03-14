#tag Class
Protected Class OverlayScrollBars
Inherits Canvas
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  
		  // mouse was pressed while scrollbar is visible
		  
		  if ShowVerticalBar or ShowHorizontalBar then
		    
		    // check if the user clicked inside vertical bar
		    if VerticalBarVisible and isOverVerticalBar then
		      
		      // stop the timer, we want to keep the scrollBar visible
		      VerticalHideTimer.mode = Timer.ModeOff
		      VerticalBarColor = kBarColor
		      
		      // check if the horizontal bar is visible
		      if HorizontalBarVisible then
		        
		        // stop the timer even for the horizontal bar to keep it visible
		        HorizontalHideTimer.mode = Timer.ModeOff
		        HorizontalBarColor = kBarColor
		        
		      end if
		      
		      // check if clicked over the the handle
		      if VerticalBarRect.Contains(new REALbasic.Point(X, Y)) then
		        // keep track we are in the process of dragging the vertical bar
		        IsVerticalBarClicked = true
		      else
		        IsVerticalScrollClicked = true
		      end if
		      
		      // remember where the click occured
		      lastY = Y
		      
		      // return true to continue the drag or mouseUp
		      return true
		      
		      // check if the user clicked inside the horizontal bar
		    elseif HorizontalBarVisible and isOverHorizontalBar then
		      
		      // stop the timer, we want to keep the scrollBar visible
		      HorizontalHideTimer.mode = Timer.ModeOff
		      HorizontalBarColor = kBarColor
		      
		      // check if the vertical bar is visible
		      if VerticalBarVisible then
		        
		        // stop the timer even for the vertical bar to keep it visible
		        VerticalHideTimer.mode = Timer.ModeOff
		        VerticalBarColor = kBarColor
		        
		      end if
		      
		      // check if clicked over the handle
		      if HorizontalBarRect.Contains(new REALbasic.Point(X, Y)) then
		        // keep track we are in the process of dragging the horizontal bar
		        IsHorizontalBarClicked = true
		      else
		        IsHorizontalScrollClicked = true
		      end if
		      
		      // remember where the click occured
		      lastX = X
		      
		      // return true to continue the drag or mouseUp
		      return true
		      
		    else // clicked outside bars or bars are not shown
		      
		      // just raise the instance event
		      return raiseEvent MouseDown(X, Y)
		      
		    end if
		    
		  else // no bars visible
		    
		    // just raise the instance event
		    return raiseEvent MouseDown(X, Y)
		    
		  end if
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(X As Integer, Y As Integer)
		  
		  // if clicked inside the handle of one bar
		  // change the value dragging the handle
		  
		  // clicked and holding the vertical bar
		  if IsVerticalBarClicked then
		    
		    // calculate the increment
		    dim incStep as double = (self.height-2) / VerticalMaximum * (1-VerticalBarRatio)
		    
		    // calculate the delta of vertical movement
		    dim deltaY as integer = Y - lastY
		    
		    // check if the relative movement is equal or greather of the step
		    if abs(deltaY) >= incStep then
		      
		      // increment (or decrement) the vertical value
		      self.VerticalValue = self.VerticalValue + (deltaY / incStep)
		      
		      // store last drag Y point
		      lastY = Y
		      
		    end if
		    
		    // clicked and holding the horizontal bar
		  elseif IsHorizontalBarClicked then
		    
		    // calculate the increment
		    dim incStep as double = (self.width-2) / HorizontalMaximum * (1-HorizontalBarRatio)
		    
		    // calculate the delta of horizontal movement
		    dim deltaX as integer = X - lastX
		    
		    // check if the relative movement is equal or greather of the step
		    if abs(deltaX) >= incStep then
		      
		      // increment (or decrement) the vertical value
		      self.HorizontalValue = self.HorizontalValue + (deltaX / incStep)
		      
		      // store last drag X point
		      lastX = X
		      
		    end if
		    
		  end if
		  
		  // raise the instance event
		  raiseEvent MouseDrag(X, Y)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseExit()
		  
		  // exiting from control should hide the bars if visible
		  
		  // only if mouse is up
		  if not IsHorizontalBarClicked and not IsVerticalBarClicked then
		    if VerticalBarVisible then
		      isOverVerticalBar = false
		      VerticalHideTimer.Reset
		    end if
		    
		    if HorizontalBarVisible then
		      isOverHorizontalBar = false
		      HorizontalHideTimer.Reset
		    end if
		  end if
		  
		  // raise the instance event
		  raiseEvent MouseExit
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseMove(X As Integer, Y As Integer)
		  
		  // if the cursor moves over a visible bar, stop the timers and keep the bars visible
		  
		  // check if the vertical bar is visible
		  if VerticalBarVisible then
		    
		    // check if the cursor is over the vertical bar area
		    if X > self.width-17 then
		      
		      // change it only if not already set
		      if not isOverVerticalBar then
		        
		        // mark the cursor is over vertical bar area
		        isOverVerticalBar = true
		        
		        // mark the vertical bar is now expanded
		        isExpandedVertical = true
		        
		        // mark the horizontal bar is no longer expanded
		        isExpandedHorizontal = false
		        
		        // stop the timer, we want to keep the scrollBar visible
		        VerticalHideTimer.mode = Timer.ModeOff
		        VerticalBarVisible = true
		        VerticalBarColor = kBarColor
		        self.invalidate
		        
		      end if
		      
		      // check if the horizontal bar need to be shown
		      if ShowHorizontalBar and ( HorizontalValue > 0 or HorizontalBarSize < self.width - 8 ) then
		        
		        // show the horizontal bar and stop the timer to keep it visible
		        HorizontalBarVisible = true
		        HorizontalHideTimer.mode = Timer.ModeOff
		        HorizontalBarColor = kBarColor
		        self.invalidate
		        
		      end if
		      
		      // the cursor is no (longer) over the vertical bar area and neither in horizontal bar area
		    elseif Y < self.height-16 then
		      
		      if isOverVerticalBar then
		        isOverVerticalBar = false
		        // restart the timer to hide the vertical bar
		        VerticalHideTimer.Reset
		        
		        // check if the horizontal bar was visible
		        if HorizontalBarVisible then
		          
		          // restart the timer to hide it
		          HorizontalHideTimer.Reset
		          
		        end if
		      end if
		    end if
		    
		  end if
		  
		  
		  // check if the horizontal bar is visible
		  if HorizontalBarVisible then
		    
		    // check if the cursor is over the horizontal bar area
		    if Y > self.height-17 then
		      
		      if not isOverHorizontalBar then
		        // mark the cursor is inside horizontal bar area
		        isOverHorizontalBar = true
		        isExpandedHorizontal = true
		        isExpandedVertical = false
		        
		        // stop the timer, we want to keep the scrollBar visible
		        HorizontalHideTimer.mode = Timer.ModeOff
		        HorizontalBarVisible = true
		        HorizontalBarColor = kBarColor
		        self.invalidate
		        
		      end if
		      
		      // check if the vertical bar need to be shown
		      if ShowVerticalBar and VerticalBarSize < self.height - 8 then
		        
		        // show the horizontal bar and stop the timer to keep it visible
		        VerticalBarVisible = true
		        VerticalHideTimer.mode = Timer.ModeOff
		        VerticalBarColor = kBarColor
		        self.invalidate
		        
		      end if
		      
		      // the cursor is no (longer) over the horizontal bar area and neither in vertical bar area
		    elseif X < self.width-16 then
		      
		      if isOverHorizontalBar then
		        isOverHorizontalBar = false
		        
		        // restart the timer to hide the horizontal bar
		        HorizontalHideTimer.Reset
		        
		        // check if the vertical bar was visible
		        if VerticalBarVisible then
		          
		          // restart the timer to hide it
		          VerticalHideTimer.Reset
		          
		        end if
		        
		      end if
		    end if
		  end if
		  
		  // raise the instance event
		  raiseEvent MouseMove( X, Y )
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  
		  if IsVerticalScrollClicked then
		    
		    if Y < VerticalBarRect.Top then
		      self.VerticalValue = self.VerticalValue - self.owner.height/self.owner.RowHeight + 4
		    else
		      self.VerticalValue = self.VerticalValue + self.owner.height/self.owner.RowHeight - 2
		    end if
		    
		  elseif IsHorizontalScrollClicked then
		    
		    if X < HorizontalBarRect.Left then
		      self.HorizontalValue = self.HorizontalValue - self.owner.width
		    else
		      self.HorizontalValue = self.HorizontalValue + self.owner.width
		    end if
		    
		  end if
		  
		  
		  // clear the flag to indicate bars are not clicked anymore
		  IsVerticalBarClicked = false
		  IsVerticalScrollClicked = false
		  IsHorizontalBarClicked = false
		  IsHorizontalScrollClicked = false
		  
		  // reset the timer to hide the vertical scrollBar
		  // if visible and the cursor is out of both vertical and horizontal area
		  if VerticalBarVisible _
		    and ( X < self.width-16 or X >= self.width ) _
		    and ( Y < self.height-16 or Y >= self.height ) then
		    VerticalHideTimer.Reset
		  end if
		  
		  // reset the timer to hide the horizontal scrollBar
		  // if visible and the cursor is out of both vertical and horizontal area
		  if HorizontalBarVisible _
		    and ( X < self.width-16 or X >= self.width ) _
		    and ( Y < self.height-16 or Y >= self.height ) then
		    HorizontalHideTimer.Reset
		  end if
		  
		  // raise the instance event
		  raiseEvent MouseUp(X, Y)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseWheel(X As Integer, Y As Integer, deltaX as Integer, deltaY as Integer) As Boolean
		  
		  // call the handler or the instance event
		  return HandleMouseWheel( X, Y, deltaX, deltaY ) or raiseEvent MouseWheel( X, Y, deltaX, deltaY )
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Open()
		  
		  // check we are on the right platform
		  dim vers as integer
		  
		  // for Mac check if we are on OSX 10.7> or not
		  #if targetMacOS then
		    vers = GetOSXVersion()
		  #endif
		  
		  // on Windows do not show overlay scrollBars
		  #if targetWin32
		    self.visible = false
		    return
		  #endif
		  
		  // on OS X prior to 10.7 Lion do not show overlay scrollBars
		  if vers < 100700 then
		    self.visible = false
		    return
		  end if
		  
		  // check setting for the scrollbars (if not set to ignore them)
		  if not IgnoreScrollbarSettings and not OverlayEnabled() then
		    self.visible = false
		    return
		  end if
		  
		  // check the parent is a Listbox or raise an exception
		  if self.parent isA ListBox then
		    Owner = Listbox(self.parent)
		  else
		    dim exc as new RuntimeException
		    exc.Message = "Parent needs to be a Listbox"
		    raise exc
		  end if
		  
		  // check the user wants scrollBars
		  ShowVerticalBar = owner.ScrollBarVertical
		  ShowHorizontalBar = owner.ScrollBarHorizontal
		  
		  // if the user do not want both scrollBars just disable me
		  if not ShowVerticalBar and not ShowHorizontalBar then
		    self.visible = false
		    return
		  end if
		  
		  // set size
		  self.left = owner.left
		  self.width = owner.width
		  if owner.hasHeading then
		    self.top = owner.top+owner.headerHeight
		    self.height = owner.height-owner.headerHeight
		  else
		    self.top = owner.top
		    self.height = owner.height
		  end if
		  
		  // set locks
		  self.lockTop = true
		  self.lockBottom = true
		  self.lockRight = true
		  self.lockLeft = true
		  
		  // set the color for the bars
		  VerticalBarColor = kBarColor
		  HorizontalBarColor = kBarColor
		  
		  // hide the owner listbox scrollBars
		  owner.ScrollBarVertical = false
		  owner.ScrollBarHorizontal = false
		  
		  // instantiate timer to auto-hide the vertical bar if needed
		  if ShowVerticalBar then
		    VerticalHideTimer = new Timer
		    AddHandler VerticalHideTimer.Action, weakAddressOf VerticalHideTimerAction
		    VerticalHideTimer.period = kHideTimerPeriod
		  end if
		  
		  // instantiate timer to auto-hide the horizontal bar if needed
		  if ShowHorizontalBar then
		    HorizontalHideTimer = new Timer
		    AddHandler HorizontalHideTimer.Action, weakAddressOf HorizontalHideTimerAction
		    HorizontalHideTimer.period = kHideTimerPeriod
		  end if
		  
		  // instantiate timer to fade the vertical bar color on hiding if needed
		  if ShowVerticalBar then
		    VerticalFadeTimer = new Timer
		    AddHandler VerticalFadeTimer.Action, weakAddressOf VerticalFadeTimerAction
		    VerticalFadeTimer.period = kFadeTimerPeriod
		  end if
		  
		  // instantiate timer to fade the horizontal bar color on hiding if needed
		  if ShowHorizontalBar then
		    HorizontalFadeTimer = new Timer
		    AddHandler HorizontalFadeTimer.Action, weakAddressOf HorizontalFadeTimerAction
		    HorizontalFadeTimer.period = kFadeTimerPeriod
		  end if
		  
		  // hijack the MouseWheel event from parent
		  AddHandler Owner.MouseWheel, weakAddressOf OwnerMouseWheelHandler
		  
		  // raise the instance event
		  raiseEvent Open
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  
		  // check if vertical bar should be made invisible
		  if ShowVerticalBar then
		    
		    // handle the case when the listbox grown vertically but the first visible cell doesn't change
		    // to fit the new space. fill empty cells with data
		    if owner.listcount - VerticalValue + 1 < ( ( self.height - 2 ) / owner.rowHeight ) then
		      VerticalValue = owner.listcount - ( ( self.height - 2 ) / owner.rowHeight ) + 1
		    end if
		    
		    // if the bar is visible but need to be hidden
		    if self.VerticalBarVisible and VerticalBarSize >= self.height - 8 then
		      
		      // hide the bar
		      self.VerticalBarVisible = false
		      
		      // check if bar is visible
		    elseif self.VerticalBarVisible then
		      
		      if isExpandedVertical then
		        // make a rect of the bar for easily check when the user clicks it
		        VerticalBarRect = new REALbasic.Rect( g.width-14, VerticalBarPosition, 11, VerticalBarSize )
		        
		        // draw the backgound rect
		        g.foreColor = kBackColor
		        g.fillRect g.width-16, 1, 15, g.height-2
		        
		        // draw the border
		        g.foreColor = kBorderColor
		        g.drawline g.width-17, 1, g.width-17, g.height-2
		        
		        // set the bar color
		        g.foreColor = VerticalBarColor
		        
		        // draw the oval bar
		        g.fillRoundRect VerticalBarRect.left, VerticalBarRect.top, VerticalBarRect.width, VerticalBarRect.height, 20, 10
		      else
		        // make a rect of the bar for easily check when the user clicks it
		        VerticalBarRect = new REALbasic.Rect( g.width-10, VerticalBarPosition, 7, VerticalBarSize )
		        
		        // set the bar color
		        g.foreColor = VerticalBarColor
		        
		        // draw the oval bar
		        g.fillRoundRect VerticalBarRect.left, VerticalBarRect.top, VerticalBarRect.width, VerticalBarRect.height, 20, 8
		      end if
		      
		    end if
		    
		  end if
		  
		  // check if horizontal bar should be made invisible
		  if ShowHorizontalBar then
		    
		    // handle the case when the listbox grown horizontally but the scroll position doesn't change
		    // to fit the new space. fill empty space with data
		    if HorizontalMaxWidth -  self.width < (HorizontalValue ) then
		      HorizontalValue = HorizontalMaxWidth - ( self.width ) + 1
		    end if
		    
		    // if the bar is visible but need to be hidden
		    if self.HorizontalBarVisible and HorizontalBarSize > self.width - 8 and HorizontalValue = 0 then
		      
		      // hide the bar
		      self.HorizontalBarVisible = false
		      
		      // check if bar is visible
		    elseif self.HorizontalBarVisible then
		      
		      if isExpandedHorizontal then
		        // make a rect of the bar for easily check when the user clicks it
		        HorizontalBarRect = new REALbasic.Rect( HorizontalBarPosition, g.height-14, HorizontalBarSize, 11 )
		        
		        // draw the backgound rect
		        g.foreColor = kBackColor
		        g.fillRect 1, g.height-16, g.width-2, 15
		        
		        // draw the border
		        g.foreColor = kBorderColor
		        g.drawline 1, g.height-17, g.width-2, g.height-17
		        
		        // set the bar color
		        g.foreColor = HorizontalBarColor
		        
		        // draw the oval bar
		        g.fillRoundrect HorizontalBarRect.left, HorizontalBarRect.top, HorizontalBarRect.width, HorizontalBarRect.height, 10, 20
		      else
		        // make a rect of the bar for easily check when the user clicks it
		        HorizontalBarRect = new REALbasic.Rect( HorizontalBarPosition, g.height-10, HorizontalBarSize, 7 )
		        
		        // set the bar color
		        g.foreColor = HorizontalBarColor
		        
		        // draw the oval bar
		        g.fillRoundrect HorizontalBarRect.left, HorizontalBarRect.top, HorizontalBarRect.width, HorizontalBarRect.height, 8, 20
		      end if
		      
		    end if
		    
		  end if
		  
		  // raise the instance event
		  raiseEvent Paint( g, areas )
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function GetOSXVersion() As Integer
		  
		  // get version of OSX as an integer
		  // with format VVSSDD where
		  //   V = version
		  //   S = subversion
		  //   D = debug version
		  // e.g: 100705 for OS version 10.7.5
		  
		  #if TargetMacOS
		    
		    static version as Integer
		    
		    if version = 0 then
		      dim sys1, sys2, sys3 as Integer
		      call System.Gestalt("sys1", sys1)
		      call System.Gestalt("sys2", sys2)
		      call System.Gestalt("sys3", sys3)
		      
		      version = 10000 * sys1 + 100 * sys2 + sys3
		    end
		    
		    return version
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HandleMouseWheel(X as Integer, Y as Integer, deltaX as Integer, deltaY as Integer) As Boolean
		  
		  #pragma unused X
		  #pragma unused Y
		  #pragma unused deltaY
		  
		  // this method handle the MouseWheel event coming from both this class and the owner
		  
		  // workaround a bug in Xojo: X, Y coordinates should be relative to control
		  // but they are relative to the window
		  X = X - self.left
		  Y = Y - self.top
		  
		  // make visible the vertical bar if needed, with a timer to make it disappear automatically
		  if ShowVerticalBar then
		    
		    // check if the vertical bar is not visible
		    if not VerticalbarVisible then
		      
		      // check if the vertical bar must be shown
		      if VerticalBarSize < self.height - 8 then
		        
		        // check if the cursor is over the vertical bar area
		        if X > self.width-17 then
		          isExpandedVertical = true
		          isExpandedHorizontal = false
		          isOverVerticalBar = true
		        end if
		        
		        // make the bar visible
		        self.VerticalBarVisible = true
		        
		        // reset the timer to hide it but only if the cursor is outside the scrollbars area
		        if not isOverVerticalBar and not isOverHorizontalBar then
		          VerticalHideTimer.Reset
		        end if
		      end if
		      
		    else
		      
		      // reset the timer to hide it but only if the cursor is outside the scrollbars area
		      if not isOverVerticalBar and not isOverHorizontalBar then
		        VerticalHideTimer.Reset
		      end if
		      
		    end if
		    
		  end if
		  
		  
		  // make visible the horizontal bar if needed, with a timer to make it disappear automatically
		  if ShowHorizontalBar then
		    
		    // the new value of the bar from relative movement
		    HorizontalValue = HorizontalValue + deltaX
		    
		    // check if the horizontal bar is not visible
		    if not HorizontalBarVisible then
		      
		      // check if the horizontal bar must be shown
		      if HorizontalValue > 0 or HorizontalBarSize < self.width - 8 then
		        
		        // check if the cursor is over the horizontal bar area
		        if Y > self.height-17 then
		          isExpandedHorizontal = true
		          isExpandedVertical = false
		          isOverHorizontalBar = true
		        end if
		        
		        // make the bar visible
		        self.HorizontalBarVisible = true
		        
		        // reset the timer to hide it but only if the cursor is outside the scrollbars area
		        if not isOverVerticalBar and not isOverHorizontalBar then
		          HorizontalHideTimer.Reset
		        end if
		        
		      end if
		      
		    else
		      
		      // reset the timer to hide it but only if the cursor is outside the scrollbars area
		      if not isOverVerticalBar and not isOverHorizontalBar then
		        HorizontalHideTimer.Reset
		      end if
		      
		    end if
		    
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HorizontalBarPosition() As Double
		  
		  // calculate horizontal bar position basing on current Value
		  
		  return ( ( ( self.width - 2.0 ) / HorizontalMaximum * HorizontalValue ) + 1 ) * ( 1.0 - HorizontalBarRatio ) + 4
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HorizontalBarRatio() As Double
		  
		  // calculate the horizontal bar ratio to determine the size
		  
		  return max( self.width / ( HorizontalMaximum + self.width ), 0.05 )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HorizontalBarSize() As Double
		  
		  // calculate the horizontal bar size depending on ratio
		  
		  return ( self.width - 2.0 ) * HorizontalBarRatio - 6
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HorizontalFadeTimerAction(sender as Timer)
		  
		  // the action wired to the HorizontalFadeTimer Action event
		  
		  // fade the bar until transparent
		  
		  // if a bar must be shown again, bail out
		  if isOverHorizontalBar or isOverVerticalBar then
		    return
		  end if
		  
		  // get current alpha value of bar handle color
		  dim alpha as integer = HorizontalBarColor.Alpha
		  
		  // we will increment the alpha up to 0xFF in steps of 0x20
		  // until the alpha is 0xFF (fully transparent)
		  if alpha < &HFF then
		    
		    // increment the alpha value of one step
		    HorizontalBarColor = RGB( 0, 0, 0, alpha + &h20 )
		    
		    // invalidate the rect to force redraw the bar
		    self.invalidate( HorizontalBarRect.left, HorizontalBarRect.top, HorizontalBarRect.Width, HorizontalBarRect.height )
		    
		  else // the bar handle is now invisible
		    
		    // stop the timer
		    sender.Mode = Timer.ModeOff
		    
		    // hide the scrollBar
		    self.HorizontalBarVisible = false
		    self.isExpandedHorizontal = false
		    self.isOverHorizontalBar = false
		    self.invalidate
		    
		    // reset the start color for the next time is shown
		    HorizontalBarColor = kBarColor
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HorizontalHideTimerAction(sender as Timer)
		  
		  #pragma unused sender
		  
		  // the action wired to the HorizontalHideTimer Action event
		  
		  // start the timer to fade the bar handle
		  HorizontalFadeTimer.Reset
		  HorizontalFadeTimer.Mode = Timer.ModeMultiple
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HorizontalMaximum() As Integer
		  
		  // calculate the Maximum value for the Horizontal ScrollBar
		  
		  return max( HorizontalMaxWidth - self.width, 0 )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HorizontalMaxWidth() As Integer
		  
		  // calculate the Maximum horizontal width
		  
		  static totalWidth as integer
		  static columnCount as integer = owner.columnCount
		  
		  if totalwidth = 0 or columnCount <> owner.columnCount then
		    // parse all columns and make a sum of current column sizes
		    totalWidth = 0
		    dim n as integer = owner.columnCount - 1
		    
		    for i as integer = 0 to n
		      totalWidth = totalWidth + owner.Column(i).widthActual
		    next
		    
		  end if
		  
		  return totalWidth
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function OverlayEnabled() As boolean
		  
		  dim returnValue as boolean
		  
		  #if targetMacOS then
		    
		    declare function NSClassFromString lib CocoaLib (className as CFStringRef) as ptr
		    declare function standardUserDefaults lib CocoaLib selector "standardUserDefaults" (id as ptr) as ptr
		    declare function stringForKey lib CocoaLib selector "stringForKey:" (id as ptr, defaultName as CFStringRef) as CFStringRef
		    
		    dim userDefaultsClass as ptr = NSClassFromString("NSUserDefaults")
		    dim userDefaults as ptr = standardUserDefaults(userDefaultsClass)
		    
		    dim result as string = stringForKey(userDefaults, "AppleShowScrollBars")
		    
		    select case result
		      
		    case "Automatic", "WhenScrolling"
		      returnValue = true
		      
		    case "Always", ""
		      returnValue = false
		      
		    end select
		    
		  #endif
		  
		  return returnValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function OwnerMouseWheelHandler(sender as RectControl, X as Integer, Y as Integer, deltaX as Integer, deltaY as Integer) As Boolean
		  
		  #pragma unused sender
		  
		  // handle MouseWheel event for the owner Listbox
		  
		  return HandleMouseWheel( X, Y, deltaX, deltaY )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function VerticalBarPosition() As Double
		  
		  // calculate vertical bar position basing on current Value
		  
		  return ( ( ( self.height - 2.0 ) / VerticalMaximum * VerticalValue ) + 1 ) * ( 1.0 - VerticalBarRatio ) + 4
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function VerticalBarRatio() As Double
		  
		  // calculate vertical bar ratio to determine the size
		  
		  return max( ( self.height-2.0 ) / ( owner.listCount * owner.rowHeight ), 0.05 )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function VerticalBarSize() As Double
		  
		  // calculate the vertical bar size depending on ratio
		  
		  return max(( self.height - 2.0 ) * VerticalBarRatio - 6, 20)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub VerticalFadeTimerAction(sender as Timer)
		  
		  // the action wired to the VerticalFadeTimer Action event
		  
		  // fade the bar until transparent
		  
		  // if a bar must be shown again, bail out
		  if isOverVerticalBar or isOverHorizontalBar then
		    return
		  end if
		  
		  // get current alpha value of bar handle color
		  dim alpha as integer = VerticalBarColor.Alpha
		  
		  // we will increment the alpha up to 0xFF in steps of 0x20
		  // until the alpha is 0xFF (fully transparent)
		  if alpha < &HFF then
		    
		    // increment the alpha value of one step
		    VerticalBarColor = RGB(0, 0, 0, alpha + &h20)
		    
		    // invalidate the rect to force redraw the bar
		    self.invalidate( VerticalBarRect.left, VerticalBarRect.top, VerticalBarRect.Width, VerticalBarRect.height )
		    
		  else // the bar handle is now invisible
		    
		    // stop the timer
		    sender.Mode = Timer.ModeOff
		    
		    // hide the scrollBar
		    self.VerticalBarVisible = false
		    self.isOverVerticalBar = false
		    self.isExpandedVertical = false
		    self.invalidate
		    
		    // reset the start color for the next time is shown
		    VerticalBarColor = kBarColor
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub VerticalHideTimerAction(sender as Timer)
		  
		  #pragma unused sender
		  
		  // the action wired to the VerticalHideTimer Action event
		  
		  // start the timer to fade the bar handle
		  VerticalFadeTimer.Reset
		  VerticalFadeTimer.Mode = Timer.ModeMultiple
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function VerticalMaximum() As Integer
		  
		  // calculate the Maximum value for the Vertical ScrollBar
		  
		  return owner.listCount - floor( ( self.height - 2.0 ) / owner.rowHeight )
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event MouseDown(X as Integer, Y as Integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseDrag(X as Integer, Y as Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseExit()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseMove(X as Integer, Y as Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseUp(X as Integer, Y as Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseWheel(X as Integer, Y as Integer, deltaX as Integer, deltaY as Integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Open()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Paint(g as Graphics, areas() as REALbasic.Rect)
	#tag EndHook


	#tag Property, Flags = &h21
		Private HorizontalBarColor As Color = &c000000
	#tag EndProperty

	#tag Property, Flags = &h21
		Private HorizontalBarRect As REALbasic.Rect
	#tag EndProperty

	#tag Property, Flags = &h21
		Private HorizontalBarVisible As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private HorizontalFadeTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private HorizontalHideTimer As Timer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  
			  // to get the scrollBar.value we need the Listbox.scrollPositionX
			  if owner <> nil then
			    return owner.scrollPositionX
			  end if
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  
			  // setting a value automatically change the parent.scrollPositionX
			  if owner <> nil then
			    owner.scrollPositionX = min( max( 0, value ), self.HorizontalMaximum )
			  end if
			  
			End Set
		#tag EndSetter
		HorizontalValue As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		IgnoreScrollbarSettings As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private isExpandedHorizontal As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private isExpandedVertical As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IsHorizontalBarClicked As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private isHorizontalScrollClicked As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private isOverHorizontalBar As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private isOverVerticalBar As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IsVerticalBarClicked As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private isVerticalScrollClicked As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private lastX As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private lastY As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private owner As ListBox
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ShowHorizontalBar As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ShowVerticalBar As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private VerticalBarColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private VerticalBarRect As REALbasic.Rect
	#tag EndProperty

	#tag Property, Flags = &h21
		Private VerticalBarVisible As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private VerticalFadeTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private VerticalHideTimer As Timer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  
			  // to get the scrollBar.value we need the Listbox.scrollPosition
			  if owner <> nil then
			    return owner.scrollPosition
			  end if
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  
			  // setting a value automatically change the parent.scrollPosition
			  if owner <> nil then
			    owner.scrollPosition = min( max( 0, value ), self.VerticalMaximum )
			  end if
			  
			End Set
		#tag EndSetter
		VerticalValue As Integer
	#tag EndComputedProperty


	#tag Constant, Name = CocoaLib, Type = String, Dynamic = False, Default = \"Cocoa.framework", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kBackColor, Type = Color, Dynamic = False, Default = \"&c000000F0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kBarColor, Type = Color, Dynamic = False, Default = \"&c0000007F", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kBorderColor, Type = Color, Dynamic = False, Default = \"&c000000C6", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kFadeTimerPeriod, Type = Double, Dynamic = False, Default = \"50", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kHideTimerPeriod, Type = Double, Dynamic = False, Default = \"250", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="AcceptFocus"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AcceptTabs"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=true
			Group="Appearance"
			Type="Picture"
			EditorType="Picture"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleBuffer"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EraseBackground"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=true
			Group="Appearance"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HorizontalValue"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IgnoreScrollbarSettings"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Group="Initial State"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="VerticalValue"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
