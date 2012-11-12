local Liquorice = CreateFrame("Frame", nil, UIParent)
Liquorice:RegisterEvent("AUCTION_HOUSE_SHOW")
local _G = _G
local GetAuctionSort = GetAuctionSort

local function AUCTION_HOUSE_SHOW(frame, event, ...)
	local AuctionFrame_OnClickSortColumn = AuctionFrame_OnClickSortColumn
	local SortButton_UpdateArrow = SortButton_UpdateArrow

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
		SortButton_UpdateArrow(BrowseBuyoutSort, "list", "buyout")
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
		SortButton_UpdateArrow(BrowseNameSort, "list", "name")
	end)
	BrowseNameSort:ClearAllPoints()
	BrowseNameSort:SetPoint("TOPLEFT", "AuctionFrameBrowse", "TOPLEFT", 186, -82)
	BrowseNameSort:Show()

	-- Re-anchor standard quality sort button
	BrowseQualitySort:ClearAllPoints()
	BrowseQualitySort:SetPoint("LEFT", "BrowseNameSort", "RIGHT", -2, 0)
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
	-- Hook this to hide arrows nicely.
	hooksecurefunc("AuctionFrameBrowse_UpdateArrows", function()
		SortButton_UpdateArrow(BrowseBuyoutSort, "list", "buyout")
		SortButton_UpdateArrow(BrowseNameSort, "list", "name")
	end)

	-- Set button widths properly on first run
	BrowseCurrentBidSort:SetWidth(207)

	-- Finally, remove the SetScript so we don't do this every time we open the AH window.
	Liquorice:SetScript("OnEvent", nil)
	Liquorice:UnregisterEvent("AUCTION_HOUSE_SHOW")
	AUCTION_HOUSE_SHOW = nil
end

Liquorice:SetScript("OnEvent", AUCTION_HOUSE_SHOW)
