function CL_MakeQListFunc()
	CL_QuestListFramePos = CreateFrame("frame", "CLQListFPos", UIParent)
	CL_QuestListFramePos:SetWidth(1)
	CL_QuestListFramePos:SetHeight(1)
	CL_QuestListFramePos:SetMovable(true)
	CL_QuestListFramePos:EnableMouse(true)
	CL_QuestListFramePos:SetFrameStrata("MEDIUM")
	CL_QuestListFramePos:SetPoint("TOPLEFT", UIParent, "TOPLEFT", ConsLegionSavedVar[CL_tempname].Settings.left, ConsLegionSavedVar[CL_tempname].Settings.top)
	CL_QuestListFrame = CreateFrame("frame", "CLQListF", UIParent)
	CL_QuestListFrame:SetWidth(1)
	CL_QuestListFrame:SetHeight(300)
	CL_QuestListFrame:SetFrameStrata("MEDIUM")
	CL_QuestListFrame:SetPoint("CENTER", CL_QuestListFramePos, "CENTER",0,0)
	CL_QuestListFrame:SetMovable(true)
	CL_QuestListFrame:EnableMouse(true)
	CL_QuestListFrame:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" and not CL_QuestListFramePos.isMoving and ConsLegionSavedVar[CL_tempname].Settings.Lock == 0 then
			CL_QuestListFramePos:StartMoving();
			CL_QuestListFramePos.isMoving = true;
		end
	end)
	CL_QuestListFrame:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" and CL_QuestListFrame.isMoving then
			CL_QuestListFramePos:StopMovingOrSizing();
			CL_QuestListFramePos.isMoving = false;
			ConsLegionSavedVar[CL_tempname].Settings.left = CL_QuestListFramePos:GetLeft()
			ConsLegionSavedVar[CL_tempname].Settings.top = CL_QuestListFramePos:GetTop() - GetScreenHeight()
			CL_QuestListFramePos:SetPoint("TOPLEFT", ConsLegionSavedVar[CL_tempname].Settings.left, ConsLegionSavedVar[CL_tempname].Settings.top)
		end
	end)
	CL_QuestListFrame:SetScript("OnHide", function(self)
		if ( CL_QuestListFrame.isMoving ) then
			CL_QuestListFrame:StopMovingOrSizing();
			CL_QuestListFrame.isMoving = false;
		end
	end)
	local CLi
	for CLi = 1, 25 do
		CL_QuestListFrame[CLi] = CreateFrame("frame", "CLQListF"..CLi, CL_QuestListFrame)
		CL_QuestListFrame[CLi]:SetWidth(210)
		CL_QuestListFrame[CLi]:SetHeight(18)
		CL_QuestListFrame[CLi]:SetPoint("BOTTOMLEFT", CL_QuestListFrame, "BOTTOMLEFT",0,0)
		CL_QuestListFrame[CLi]:SetBackdrop( { 
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true, tileSize = 10, edgeSize = 10, insets = { left = 2, right = 2, top = 2, bottom = 2 }
		});
		CL_QuestListFrame[CLi]:SetScript("OnMouseDown", function(self, button)
			if button == "LeftButton" and not CL_QuestListFramePos.isMoving and ConsLegionSavedVar[CL_tempname].Settings.Lock == 0 then
				CL_QuestListFramePos:StartMoving();
				CL_QuestListFramePos.isMoving = true;
			end
		end)
		CL_QuestListFrame[CLi]:SetScript("OnMouseUp", function(self, button)
			if button == "LeftButton" and CL_QuestListFramePos.isMoving then
				CL_QuestListFramePos:StopMovingOrSizing();
				CL_QuestListFramePos.isMoving = false;
				ConsLegionSavedVar[CL_tempname].Settings.left = CL_QuestListFramePos:GetLeft()
				ConsLegionSavedVar[CL_tempname].Settings.top = CL_QuestListFramePos:GetTop() - GetScreenHeight()
				CL_QuestListFramePos:SetPoint("TOPLEFT", ConsLegionSavedVar[CL_tempname].Settings.left, ConsLegionSavedVar[CL_tempname].Settings.top)
			end
		end)
		CL_QuestListFrame[CLi]:SetScript("OnHide", function(self)
			if ( CL_QuestListFramePos.isMoving ) then
				CL_QuestListFramePos:StopMovingOrSizing();
				CL_QuestListFramePos.isMoving = false;
			end
		end)
		CL_QuestListFrame[CLi]:SetAlpha(0)
		CL_QuestListFrame["FS"..CLi] = CL_QuestListFrame:CreateFontString("CLQFS"..CLi,"ARTWORK", "ChatFontNormal")
		CL_QuestListFrame["FS"..CLi]:SetParent(CL_QuestListFrame[CLi])
		CL_QuestListFrame["FS"..CLi]:SetPoint("TOPLEFT",CL_QuestListFrame[CLi],"TOPLEFT",5,0)
		CL_QuestListFrame["FS"..CLi]:SetWidth(200)
		CL_QuestListFrame["FS"..CLi]:SetHeight(18)
		CL_QuestListFrame["FS"..CLi]:SetJustifyH("LEFT")
		CL_QuestListFrame["FS"..CLi]:SetFont(CL_Font, 11)
		CL_QuestListFrame["FS"..CLi]:SetText("")
		CL_QuestListFrame["FS"..CLi]:SetTextColor(1, 1, 0)
		local CLi2
		local CLi3 = 0
		for CLi2 = 1, 10 do
			CL_QuestListFrame[CLi]["F"..CLi2] = CreateFrame("frame", "CLQListF"..CLi.."F"..CLi2, CL_QuestListFrame[CLi])
			CL_QuestListFrame[CLi]["F"..CLi2]:SetWidth(180)
			CL_QuestListFrame[CLi]["F"..CLi2]:SetHeight(15)
			CL_QuestListFrame[CLi]["F"..CLi2]:SetPoint("TOPLEFT", CL_QuestListFrame[CLi], "TOPLEFT",10,-((CLi2 * 15)+2))
			CL_QuestListFrame[CLi]["F"..CLi2]:SetBackdrop( { 
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tile = true, tileSize = 10, edgeSize = 10, insets = { left = 2, right = 2, top = 2, bottom = 2 }
			});
			CL_QuestListFrame[CLi]["F"..CLi2]:SetScript("OnMouseDown", function(self, button)
				if button == "LeftButton" and not CL_QuestListFramePos.isMoving and ConsLegionSavedVar[CL_tempname].Settings.Lock == 0 then
					CL_QuestListFramePos:StartMoving();
					CL_QuestListFramePos.isMoving = true;
				end
			end)
			CL_QuestListFrame[CLi]["F"..CLi2]:SetScript("OnMouseUp", function(self, button)
				if button == "LeftButton" and CL_QuestListFramePos.isMoving then
					CL_QuestListFramePos:StopMovingOrSizing();
					CL_QuestListFramePos.isMoving = false;
					ConsLegionSavedVar[CL_tempname].Settings.left = CL_QuestListFramePos:GetLeft()
					ConsLegionSavedVar[CL_tempname].Settings.top = CL_QuestListFramePos:GetTop() - GetScreenHeight()
					CL_QuestListFramePos:SetPoint("TOPLEFT", ConsLegionSavedVar[CL_tempname].Settings.left, ConsLegionSavedVar[CL_tempname].Settings.top)
				end
			end)
			CL_QuestListFrame[CLi]["F"..CLi2]:SetScript("OnHide", function(self)
				if ( CL_QuestListFramePos.isMoving ) then
					CL_QuestListFramePos:StopMovingOrSizing();
					CL_QuestListFramePos.isMoving = false;
				end
			end)
--			CL_QuestListFrame[CLi]["F"..CLi2]:SetAlpha(1)
			CL_QuestListFrame[CLi]["F"..CLi2]:Hide()
			CL_QuestListFrame["FS"..CLi.."FS"..CLi2] = CL_QuestListFrame:CreateFontString("CLQFS"..CLi.."FS"..CLi2,"ARTWORK", "ChatFontNormal")
			CL_QuestListFrame["FS"..CLi.."FS"..CLi2]:SetParent(CL_QuestListFrame[CLi]["F"..CLi2])
			CL_QuestListFrame["FS"..CLi.."FS"..CLi2]:SetPoint("TOPLEFT",CL_QuestListFrame[CLi]["F"..CLi2],"TOPLEFT",5,-2)
			CL_QuestListFrame["FS"..CLi.."FS"..CLi2]:SetWidth(170)
			CL_QuestListFrame["FS"..CLi.."FS"..CLi2]:SetHeight(12)
			CL_QuestListFrame["FS"..CLi.."FS"..CLi2]:SetJustifyH("LEFT")
			CL_QuestListFrame["FS"..CLi.."FS"..CLi2]:SetFont(CL_Font, 9)
			CL_QuestListFrame["FS"..CLi.."FS"..CLi2]:SetText("")
			CL_QuestListFrame["FS"..CLi.."FS"..CLi2]:SetTextColor(1, 1, 0)
			for CLi3 = 1, 4 do
				CL_QuestListFrame[CLi]["F"..CLi2]["F"..CLi3] = CreateFrame("frame", "CLQListF"..CLi.."F"..CLi2.."F"..CLi3, CL_QuestListFrame[CLi]["F"..CLi2])
				CL_QuestListFrame[CLi]["F"..CLi2]["F"..CLi3]:SetWidth(30)
				CL_QuestListFrame[CLi]["F"..CLi2]["F"..CLi3]:SetHeight(15)
				CL_QuestListFrame[CLi]["F"..CLi2]["F"..CLi3]:SetPoint("TOPLEFT", CL_QuestListFrame[CLi]["F"..CLi2], "TOPLEFT",-((CLi3 * 30)+2),0)
				CL_QuestListFrame[CLi]["F"..CLi2]["F"..CLi3]:SetBackdrop( { 
					edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
					tile = true, tileSize = 5, edgeSize = 4, insets = { left = 2, right = 2, top = 2, bottom = 2 }
				});
				CL_QuestListFrame[CLi]["F"..CLi2]["F"..CLi3].Background = CL_QuestListFrame[CLi]["F"..CLi2]["F"..CLi3]:CreateTexture(nil, "BACKGROUND")
				CL_QuestListFrame[CLi]["F"..CLi2]["F"..CLi3].Background:SetAllPoints()
				CL_QuestListFrame[CLi]["F"..CLi2]["F"..CLi3].Background:SetTexture(CL_bg)
				CL_QuestListFrame[CLi]["F"..CLi2]["F"..CLi3].Background:SetVertexColor(0,0,0,0.85)
				CL_QuestListFrame["FS"..CLi.."FS"..CLi2.."FS"..CLi3] = CL_QuestListFrame:CreateFontString("CLQFS"..CLi.."FS"..CLi2,"ARTWORK", "ChatFontNormal")
				CL_QuestListFrame["FS"..CLi.."FS"..CLi2.."FS"..CLi3]:SetParent(CL_QuestListFrame[CLi]["F"..CLi2]["F"..CLi3])
				CL_QuestListFrame["FS"..CLi.."FS"..CLi2.."FS"..CLi3]:SetPoint("TOP",CL_QuestListFrame[CLi]["F"..CLi2]["F"..CLi3],"TOP",0,-2)
				CL_QuestListFrame["FS"..CLi.."FS"..CLi2.."FS"..CLi3]:SetWidth(30)
				CL_QuestListFrame["FS"..CLi.."FS"..CLi2.."FS"..CLi3]:SetHeight(12)
				CL_QuestListFrame["FS"..CLi.."FS"..CLi2.."FS"..CLi3]:SetJustifyH("CENTER")
				CL_QuestListFrame["FS"..CLi.."FS"..CLi2.."FS"..CLi3]:SetFont(CL_Font, 9)
				CL_QuestListFrame["FS"..CLi.."FS"..CLi2.."FS"..CLi3]:SetText("")
				CL_QuestListFrame["FS"..CLi.."FS"..CLi2.."FS"..CLi3]:SetTextColor(1, 1, 0)
				CL_QuestListFrame[CLi]["F"..CLi2]["F"..CLi3]:Hide()
			end
		end
	end
	CL_QuestListFrame:SetScale(ConsLegionSavedVar[CL_tempname].Settings.Scale)
	CL_QuestListFrame:SetAlpha(ConsLegionSavedVar[CL_tempname].Settings.alpha)
	if (ConsLegionSavedVar[CL_tempname].Settings.Hide == 1) then
		CL_QuestListFrame:Hide()
	end
end


