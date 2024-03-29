--[[
	PanelScroller
	Version: 7.4.5714 (TasmanianThylacine)
	Revision: $Id: PanelScroller.lua 312 2011-06-14 07:33:25Z brykrys $
	URL: http://auctioneeraddon.com/dl/

	License:
		This library is free software; you can redistribute it and/or
		modify it under the terms of the GNU Lesser General Public
		License as published by the Free Software Foundation; either
		version 2.1 of the License, or (at your option) any later version.

		This library is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
		Lesser General Public License for more details.

		You should have received a copy of the GNU Lesser General Public
		License along with this library; if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor,
		Boston, MA  02110-1301  USA

	Additional:
		Regardless of any other conditions, you may freely use this code
		within the World of Warcraft game client.
--]]

local LIBRARY_VERSION_MAJOR = "PanelScroller"
local LIBRARY_VERSION_MINOR = 3
local lib = LibStub:NewLibrary(LIBRARY_VERSION_MAJOR, LIBRARY_VERSION_MINOR)
if not lib then return end

LibStub("LibRevision"):Set("$URL: http://svn.norganna.org/libs/trunk/Configator/PanelScroller.lua $","$Rev: 312 $","5.1.DEV.", 'auctioneer', 'libs')

local kit = {
	hPos = 0, hSize = 0, hWin = 0, hType = "AUTO",
	vPos = 0, vSize = 0, vWin = 0, vType = "YES",
}
local abs = abs

-- Set whether to allow horizontal scrolling ("YES", "NO" or "AUTO")
function kit:SetScrollBarVisible(axis, visibility)
	if not (visibility == "YES"
		or visibility == "NO"
		or visibility == "AUTO"
		or visibility == "FAUX"
	) then
		return error("Invalid visibility, must be one of YES, NO or AUTO")
	end
	if axis == "HORIZONTAL" then
		self.hType = visibility
	elseif axis == "VERTICAL" then
		self.vType = visibility
	else
		return error("Invalid axis type, must be one of HORIZONTAL or VERTICAL")
	end

	self:Update()
end

function kit:MouseScroll(direction)
	if self.vType == "NO" then
		if self.hType == "FAUX" then
			self:ScrollByPixels("HORIZONTAL", -1 * direction)
		elseif self.hType ~= "NO" then
			self:ScrollByPercent("HORIZONTAL", -0.1 * direction)
		end
	elseif self.vType == "FAUX" then
		self:ScrollByPixels("VERTICAL", -1 * direction)
	else
		self:ScrollByPercent("VERTICAL", -0.1 * direction)
	end
end

-- Performs a scroll along the specified axis by a given percentage of the window size
--This % will always be 1 page of datain the vertical direction
function kit:ScrollByPercent(axis, percent)
	local scrollbar, curpos, winsize, scrollrange
	if axis == "HORIZONTAL" then
		scrollbar = self.hScroll
		scrollrange = self.hSize
		winsize = self.hWin
		curpos = self.hPos
		--horizontal will be % of  total size
		percent = (winsize*percent)
	elseif axis == "VERTICAL" then
		scrollbar = self.vScroll
		scrollrange = self.vSize
		winsize = self.vWin
		curpos = self.vPos
		--vertical is 1 page of data varies by # of  data rows in that scrollframe or (winsize*percent)
		if self:GetParent().sheet and self:GetParent().sheet.rows then
			if percent > 0 then
				percent = #self:GetParent().sheet.rows
			else
				percent = -#self:GetParent().sheet.rows
			end
		else
			percent = (winsize*percent)
		end
	else
		return error("Unknown axis for scrolling, must be one of HORIZONTAL or VERTICAL")
	end
	local dest = math.max(0, math.min(curpos + (percent), scrollrange))
	if (abs(dest - curpos) > 0.01) then
		scrollbar:SetValue(dest)
	end
	self:ScrollSync()
end

-- Performs a scroll along the specified axis by a given number of pixels
function kit:ScrollByPixels(axis, pixels)
	local scrollbar, curpos, scrollrange
	if axis == "HORIZONTAL" then
		scrollbar = self.hScroll
		scrollrange = self.hSize
		curpos = self.hPos
	elseif axis == "VERTICAL" then
		scrollbar = self.vScroll
		scrollrange = self.vSize
		curpos = self.vPos
	else
		return error("Unknown axis for scrolling, must be one of HORIZONTAL or VERTICAL")
	end
	local dest = math.max(0, math.min(curpos + pixels, scrollrange))
	if (abs(dest - curpos) > 0.01) then
		scrollbar:SetValue(dest)
	end
	self:ScrollSync()
end

function kit:ScrollToCoords(x, y)
	if x then
		local dest = math.max(0, math.min(x, self.hSize))
		if (abs(dest - x) > 0.01) then
			self.hScroll:SetValue(dest)
		end
	end
	if y then
		local dest = math.max(0, math.min(y, self.vSize))
		if (abs(dest - y) > 0.01) then
			self.vScroll:SetValue(dest)
		end
	end
	self:ScrollSync()
end

function kit:ScrollSync()
	if (self.hType ~= "FAUX") then
		self:SetHorizontalScroll(self.hScroll:GetValue()) --removed the * -1  inversion. Scrolling >right> now uses a positive integer as of wow patch 3.3.3
	end
	if (self.vType ~= "FAUX") then
		self:SetVerticalScroll(self.vScroll:GetValue())
	end
	self:Update()
end

-- This function updates the entire scrollable unit, hidin
function kit:Update()
	self:UpdateScrollChildRect()

	if self.hType ~= "FAUX" then
		self.hSize = self:GetHorizontalScrollRange();
	end
	if self.vType ~= "FAUX" then
		self.vSize = self:GetVerticalScrollRange();
	end

	self.hPos = self.hScroll:GetValue()
	self.vPos = self.vScroll:GetValue()

	self.hWin = self:GetWidth()
	self.vWin = self:GetHeight()

	if (self.hPos > self.hSize) then self.hPos = self.hSize end
	if (self.vPos > self.vSize) then self.vPos = self.vSize end

	local hMin, hMax = self.hScroll:GetMinMaxValues()
	local vMin, vMax = self.vScroll:GetMinMaxValues()
	if abs(hMin) > 0.01 or abs(vMin) > 0.01 or
	abs(hMax-self.hSize) > 0.01 or
	abs(vMax-self.vSize) > 0.01 then
		self.hScroll:SetMinMaxValues(0, self.hSize)
		self.vScroll:SetMinMaxValues(0, self.vSize)

		self.hScroll:SetValue(self.hPos)
		self.vScroll:SetValue(self.vPos)
	end

	if self.hType == "NO" then
		self.hScroll:Hide()
	elseif self.hType == "FAUX" then
		self.hScroll:Show()
		self.hScroll.incrButton:Enable()
		self.hScroll.decrButton:Enable()
	elseif math.floor(self.hSize-30) <= 0 then
		if self.hType == "YES" then
			self.hScroll:Show()
			self.hScroll.incrButton:Disable()
			self.hScroll.decrButton:Disable()
		else
			self.hScroll:Hide()
		end
	else
		self.hScroll:Show()
		self.hScroll.incrButton:Enable()
		self.hScroll.decrButton:Enable()
	end

	if self.vType == "NO" then
		self.vScroll:Hide()
	elseif self.vType == "FAUX" then
		self.vScroll:Show()
		self.vScroll.incrButton:Enable()
		self.vScroll.decrButton:Enable()
	elseif math.floor(self.vSize) <= 0 then
		if self.vType == "YES" then
			self.vScroll:Show()
			self.vScroll.incrButton:Disable()
			self.vScroll.decrButton:Disable()
		else
			self.vScroll:Hide()
		end
	else
		self.vScroll:Show()
		self.vScroll.incrButton:Enable()
		self.vScroll.decrButton:Enable()
	end

	if self.callback then
		self.callback()
	end
end

function lib:Create(name, parent)
	local scroller = CreateFrame("ScrollFrame", name, parent, "PanelScrollerTemplate_v1")
	scroller.hScroll = _G[name.."HorizontalScrollBar"];
	scroller.vScroll = _G[name.."VerticalScrollBar"];
	for k,v in pairs(kit) do
		scroller[k] = v
	end
	return scroller
end
