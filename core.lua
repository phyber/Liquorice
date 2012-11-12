local ExtraAuctionSorts = CreateFrame("Frame", nil, UIParent)
ExtraAuctionSorts:RegisterEvent("AUCTION_HOUSE_SHOW")
local _G = _G
local GetAuctionSort = GetAuctionSort

local function UpdateArrow(button)
	local criterion, reverse = GetAuctionSort("list", 1)
	if not reverse then
		_G[button:GetName().."Arrow"]:SetTexCoord(0, 0.5625, 1.0, 0)
	else
		_G[button:GetName().."Arrow"]:SetTexCoord(0, 0.5625, 0, 1.0)
	end
end

local function AUCTION_HOUSE_SHOW(frame, event, ...)
	-- Local fixes a sizing bug later on.
	local BQSwidth = BrowseQualitySort:GetWidth()

	-- Add new sort types
	-- Sort by BuyOut
	AuctionSort['list_buyout'] = {
		{ column = 'duration',	reverse = false },
		{ column = 'quantity',	reverse = false },
		{ column = 'name',	reverse = false },
		{ column = 'level',	reverse = true },
		{ column = 'quality',	reverse = false },
		{ column = 'bid',	reverse = false },
		{ column = 'buyout',	reverse = false },
	}
	-- Sort by item name
	AuctionSort['list_name'] = {
		{ column = 'duration',	reverse = false },
		{ column = 'quantity',	reverse = false },
		{ column = 'level',	reverse = true },
		{ column = 'bid',	reverse = false },
		{ column = 'buyout',	reverse = false },
		{ column = 'quality',	reverse = false },
		{ column = 'name',	reverse = false },
	}
	-- Buyout Sort
	local BrowseBuyoutSort = CreateFrame("Button", "BrowseBuyoutSort", AuctionFrameBrowse, "AuctionSortButtonTemplate")
	BrowseBuyoutSort:SetWidth(95)
	BrowseBuyoutSort:SetHeight(19)
	BrowseBuyoutSort:SetText(BUYOUT_PRICE)
	BrowseBuyoutSort:SetScript("OnClick", function()
		AuctionFrame_OnClickSortColumn("list", "buyout")
		UpdateArrow(BrowseBuyoutSort)
	end)
	BrowseBuyoutSort:ClearAllPoints()
	BrowseBuyoutSort:SetPoint("LEFT", "BrowseCurrentBidSort", "RIGHT", -2, 0)
	BrowseBuyoutSort:Show()

	-- ItemName sort
	local BrowseNameSort = CreateFrame("Button", "BrowseNameSort", AuctionFrameBrowse, "AuctionSortButtonTemplate")
	BrowseNameSort:SetWidth(95)
	BrowseNameSort:SetHeight(19)
	BrowseNameSort:SetText(NAME)
	BrowseNameSort:SetScript("OnClick", function()
		AuctionFrame_OnClickSortColumn("list", "name")
		UpdateArrow(BrowseNameSort)
	end)
	BrowseNameSort:ClearAllPoints()
	BrowseNameSort:SetPoint("TOPLEFT", "AuctionFrameBrowse", "TOPLEFT", 186, -82)
	BrowseNameSort:Show()

	-- Re-anchor standard quality sort button
	BrowseQualitySort:ClearAllPoints()
	BrowseQualitySort:SetPoint("LEFT", "BrowseNameSort", "RIGHT", -2, 0)
	BrowseQualitySort:SetWidth(BQSwidth)
	BrowseQualitySort:SetWidth(BrowseQualitySort:GetWidth() - BrowseNameSort:GetWidth())
	BrowseQualitySort:Show()

	-- Replace the old SetWidth of BrowseCurrentBidSort
	-- Might taint, we'll see.
	do
		local oldSetWidth = BrowseCurrentBidSort.SetWidth
		BrowseCurrentBidSort.SetWidth = function(self, width)
			if width >= 180 then
				width = width - BrowseBuyoutSort:GetWidth() + 2
			end
			oldSetWidth(self, width)
		end
	end

	BrowseCurrentBidSort:SetWidth(207)

	-- Finally, remove the SetScript so we don't do this every time we open the AH window.
	ExtraAuctionSorts:SetScript("OnEvent", nil)
	ExtraAuctionSorts:UnregisterEvent("AUCTION_HOUSE_SHOW")
end

ExtraAuctionSorts:SetScript("OnEvent", AUCTION_HOUSE_SHOW)
