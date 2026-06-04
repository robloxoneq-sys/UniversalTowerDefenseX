local Knit = game:GetService("ReplicatedStorage")
    :WaitForChild("Packages")
    :WaitForChild("_Index")["sleitnick_knit@1.7.0"]
    :WaitForChild("knit")
    :WaitForChild("Services")

local CodeRemote = Knit.CodeService.RF.Redeem

for _, code in ipairs({
    "200kInterestedBeast!",
    "3.0PartTwoUpdate!",
    "FusionUpdate!",
    "MercilessGodIsHere!",
    "NewBattlePass!!",
    "UniverseFestDelay1!",
    "UniverseFestDelay2!",
    "UniverseFestDelay3!",
    "UniverseFestDelay4!",
    "UniverseFestDelay5!",
    "275kInterestedUtopia!",
    "250kInterestedUtopia!",
    "3.0Part1.5!",
    "PirateKing!",
    "WeLoveBerserker!",
    "300KInterestedUtopia"
}) do
    pcall(function()
        CodeRemote:InvokeServer(code)
    end)
end

task.wait(0.5)

local SetSetting = Knit.DataService.RE.SetSetting

for _, setting in ipairs({
    "SellLegendary",
    "SellEpic",
    "SellRare",
    "AutoSkipSummon"
}) do
    SetSetting:FireServer(setting, true)
end
task.wait(0.5)
Knit.DataService.RF.SetSelectionBannerMythic:InvokeServer("Spade")
task.wait(0.5)
Knit.ReturnRewardsService.RF.ClaimDay:InvokeServer(1)
Knit.WelcomeRewardsService.RF.ClaimDay:InvokeServer(1)
local Event = game:GetService("ReplicatedStorage")
    .Packages._Index["sleitnick_knit@1.7.0"]
    .knit.Services.DataService.RE.SetSetting

for _, setting in ipairs({
    "SellLegendary",
    "SellEpic",
    "SellRare",
    "SellTraitRare",
    "SellTraitEpic",
    "SellTraitLegendary"
}) do
    Event:FireServer(setting, false)
end
task.wait(0.5)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BuyBannerRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")["sleitnick_knit@1.7.0"].knit.Services.BannerService.RF.BuyBanner

local function RunSellScript()
    local TowerServices = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Data"):WaitForChild("Towers")
    local BulkSellRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")["sleitnick_knit@1.7.0"].knit.Services.DataService.RE.BulkSell

    local function GetIsRare(Name)
        for _, v in pairs(TowerServices:GetChildren()) do
            if v:IsA("ModuleScript") then
                local Data = require(v)
                if v.Name == Name and (Data.Rarity == "Secret" or Data.Rarity == "Mythic") then
                    return true
                end
            end
        end
        return false
    end

    local Inventory = nil
    for _, v in pairs(getgc(true)) do
        if typeof(v) == "table" and rawget(v, "Inventory") and typeof(rawget(v, "Inventory")) == "table" then
            local testInv = v.Inventory
            for _, item in pairs(testInv) do
                if typeof(item) == "table" and item.UnitId and item.GUID then
                    Inventory = testInv
                    break
                end
            end
        end
        if Inventory then break end
    end

    if not Inventory then
        local success, network = pcall(function() return require(ReplicatedStorage.Imported.network) end)
        if success and network and network.data and network.data.Inventory then
            Inventory = network.data.Inventory
        end
    end

    if Inventory then
        local ListSeller = {}
        local trashCount = 0

        for _, v in pairs(Inventory) do
            if not GetIsRare(v.UnitId) and v.GUID then
                table.insert(ListSeller, tostring(v.GUID))
                trashCount = trashCount + 1
            end
        end

        if trashCount > 0 then
            local args = {
                [1] = ListSeller
            }
            BulkSellRemote:FireServer(unpack(args))
        end
    end
end

for i = 1, 9 do
    BuyBannerRemote:InvokeServer("FiftySummon", "Special")
    task.wait(0.5)
    RunSellScript()
    task.wait(3)
end

task.wait(1)

for i = 1, 8 do
    BuyBannerRemote:InvokeServer("FiftySummon", "Universal2")
    task.wait(0.5)
    RunSellScript()
    task.wait(3)
end

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TowerServices = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Data"):WaitForChild("Towers")

local function GetIsRare(Name)
    for _, v in pairs(TowerServices:GetChildren()) do
        if v:IsA("ModuleScript") then
            local Data = require(v)
            if v.Name == Name and (Data.Rarity == "Secret" or Data.Rarity == "Mythic") then
                return true
            end
        end
    end
    return false
end

local function GetCurrentInventory()
    local Inventory = nil
    for _, v in pairs(getgc(true)) do
        if typeof(v) == "table" and rawget(v, "Inventory") and typeof(rawget(v, "Inventory")) == "table" then
            local testInv = v.Inventory
            for _, item in pairs(testInv) do
                if typeof(item) == "table" and item.UnitId and item.GUID then
                    Inventory = testInv
                    break
                end
            end
        end
        if Inventory then break end
    end
    return Inventory
end

local function UpdateDescription()
    local rareUnits = {}
    local Inventory = GetCurrentInventory()

    if Inventory then
        for _, v in pairs(Inventory) do
            if GetIsRare(v.UnitId) then
                table.insert(rareUnits, tostring(v.UnitId))
            end
        end
    else
        local success, network = pcall(function() return require(ReplicatedStorage.Imported.network) end)
        if success and network and network.data and network.data.Inventory then
            for _, v in pairs(network.data.Inventory) do
                if GetIsRare(v.UnitId) then
                    table.insert(rareUnits, tostring(v.UnitId))
                end
            end
        end
    end

    local messages = ""
    if #rareUnits > 0 then
        messages = "✨ Secret/Mythic : " .. table.concat(rareUnits, ", ")
    else
        messages = "✨ Secret/Mythic : None"
    end

    if _G.Horst_SetDescription then
        _G.Horst_SetDescription(messages)
    else
        print("[-] ไม่พบฟังก์ชัน _G.Horst_SetDescription (ข้อมูลปัจจุบัน: " .. messages .. ")")
    end
end

task.spawn(function()
    while true do
        pcall(UpdateDescription)
        task.wait(10)
    end
end)