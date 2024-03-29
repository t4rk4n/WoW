--[[ DELETE v DELETE v DELETE v DELETE v DELETE v DELETE v DELETE v DELETE --

	NOTE:
	This is an example addon. Use the below code to start your own
	module should you wish.

	This top section should bel deleted from any derivative code
	before you distribute it.

]]

if true then
	 --Comment out this return to see the example module running.
	 return
end

--^ DELETE ^ DELETE ^ DELETE ^ DELETE ^ DELETE ^ DELETE ^ DELETE ^ DELETE ^--

--[[
	Auctioneer - Price Level Utility module
	Version: 7.4.5714 (TasmanianThylacine)
	Revision: $Id: Example.lua 5347 2012-09-06 06:26:15Z Esamynn $
	URL: http://auctioneeraddon.com/

	This is an Auctioneer module that does something nifty.

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit license to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]
if not AucAdvanced then return end

local libName = "Example"
local libType = "Util"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end
local print,decode,_,_,replicate,empty,get,set,default,debugPrint,fill = AucAdvanced.GetModuleLocals()

--[[
The following functions are part of the module's exposed methods:
	GetName()         (created by NewModule) Returns libName. Should never be overridden
	GetLocalName()    (optional) Returns a localized name (NewModule creates a default version, which may be overridden)
	CommandHandler()  (optional) Slash command handler for this module
	Processors ={}    (optional) Table containing functions to process messages sent by Auctioneer
	ScanProcessors={} (optional) Table containing functions to process items during a scan
	GetPrice()        (optional) Returns estimated price for item link
	GetPriceColumns() (optional) Returns the column names for GetPrice
	OnLoad()          (optional) Receives load message for self, and for any modules specified by LoadTriggers table
	OnUnload()        (optional) Called during logout, just before data gets saved
	
	GetPriceArray()   (*) Returns pricing and other statistical info in an array
	GetItemPDF()      (**) Returns Probability Density Function for item link (see below)
	AuctionFilter()   (##) Perform filtering on an auction entry
	GetMatchArray()   ($$) Perform price matching on an item link

	* Required for Stat modules, optional for other module types
	** Required for Stat modules, not used by other module types
	## Required for Filter modules, not used by other module types
	$$ Required for Match modules, not used by other module types

]]

--[[
lib.Processor function is deprecated; it is replaced by the lib.Processors table of functions
It will be supported for a period, but should not be used when making new modules
]]
function lib.Processor(callbackType, ...)
	if (callbackType == "tooltip") then
		--Called when the tooltip is being drawn.
		lib.ProcessTooltip(...)
	elseif (callbackType == "config") then
		--Called when you should build your Configator tab.
		private.SetupConfigGui(...)
	elseif (callbackType == "listupdate") then
		--Called when the AH Browse screen receives an update.
	elseif (callbackType == "configchanged") then
		--Called when your config options (if Configator) have been changed.
	end
end
--[[
Demonstrates a quick (temporary) method of converting the old Processor function to the new Processors table
Note that the function calls are the same (including the 'callbackType' parameter)
]]
lib.Processors = {
	tooltip = lib.Processor,
	config = lib.Processor,
	listupdate = lib.Processor,
	configchanged = lib.Processor,
}


function lib.ProcessTooltip(frame, name, hyperlink, quality, quantity, cost, additional)
	-- In this function, you are afforded the opportunity to add data to the tooltip should you so
	-- desire. You are passed a hyperlink, and it's up to you to determine whether or what you should
	-- display in the tooltip.
end

function lib.OnLoad()
	--This function is called when your variables have been loaded.
	--You should also set your Configator defaults here

	print("AucAdvanced: {{"..libType..":"..libName.."}} loaded!")
	AucAdvanced.Settings.SetDefault("util.example.active", true)
	AucAdvanced.Settings.SetDefault("util.example.slider", 50)
	AucAdvanced.Settings.SetDefault("util.example.wideslider", 100)
	AucAdvanced.Settings.SetDefault("util.example.hardselectbox", 5)
	AucAdvanced.Settings.SetDefault("util.example.dynamicselectbox", 5)
	AucAdvanced.Settings.SetDefault("util.example.label", "Label")
	AucAdvanced.Settings.SetDefault("util.example.text", "")
	AucAdvanced.Settings.SetDefault("util.example.numberbox", "5")
	AucAdvanced.Settings.SetDefault("util.example.moneyframe", "50000000")
	AucAdvanced.Settings.SetDefault("util.example.moneyframepinned", "010101")
end

--[[ Local functions ]]--

function private.SetupConfigGui(gui)
	-- The defaults for the following settings are set in the lib.OnLoad function
	local id = gui:AddTab(libName)
	gui:MakeScrollable(id)
	gui:AddControl(id, "Header",     0,    libName.." options")
	gui:AddControl(id, "Checkbox",   0, 1, "util.example.active", "This is a checkbox, it has two settings true (selected) and false (cleared)")

	gui:AddControl(id, "Subhead",    0,    "There are two kinds of sliders:")
	gui:AddControl(id, "Slider",     0, 1, "util.example.slider", 0, 100, 1, "Normal Sliders: %d%%")
	gui:AddControl(id, "WideSlider", 0, 1, "util.example.wideslider",    0, 200, 1, "And Wide Sliders: %d%%")

	gui:AddControl(id, "Subhead",    0,    "There are also two ways to build a selection box:")
	gui:AddControl(id, "Selectbox",  0, 1, {
		{0, "Zero"},
		{1, "One"},
		{2, "Two"},
		{3, "Three"},
		{4, "Four"},
		{5, "Five"},
		{6, "Six"},
		{7, "Seven"},
		{8, "Eight"},
		{9, "Nine"}
	}, "util.example.hardselectbox")
	gui:AddControl(id, "Selectbox",  0, 1, private.GetNumbers, "util.example.dynamicselectbox")

	gui:AddControl(id, "Subhead",    0,    "There are also a few ways to add text:\n  The Headers and SubHeaders that you've already seen...")
	gui:AddControl(id, "Note",       0, 1, nil, nil, "Notes...")
	gui:AddControl(id, "Label",      0, 1, "util.example.label", "And Labels")

	gui:AddControl(id, "Subhead",    0,    "There are two ways to get input via keyboard:")
	gui:AddControl(id, "Text",       0, 1, "util.example.text", "Via the Text Control...")
	gui:AddControl(id, "NumberBox",  0, 1, "util.example.numberbox", 0, 9, "Or using the NumberBox if you only need numbers.")

	gui:AddControl(id, "Subhead",          0,    "There are two kinds of Money Frames:")
	gui:AddControl(id, "MoneyFrame",       0, 1, "util.example.moneyframe", "MoneyFrames...")
	gui:AddControl(id, "MoneyFramePinned", 0, 1, "util.example.moneyframepinned", 0, 101010, "And PinnedMoneyFrames.")

	gui:AddControl(id, "Subhead",    0,    "And finally...")
	gui:AddControl(id, "Button",     0, 1, "util.example.button", "The Button!")
end

function private.GetNumbers()
	return { {0, "Zero"}, {1, "One"}, {2, "Two"}, {3, "Three"}, {4, "Four"}, {5, "Five"}, {6, "Six"}, {7, "Seven"}, {8, "Eight"}, {9, "Nine"} }
end

function private.Foo()
end

function private.Bar()
end

function private.Baz()
end

AucAdvanced.RegisterRevision("$URL: http://svn.norganna.org/auctioneer/branches/7.4/Auc-Advanced/Modules/Auc-Util-Example/Example.lua $", "$Rev: 5347 $")
