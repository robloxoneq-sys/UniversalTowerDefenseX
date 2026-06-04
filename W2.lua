local Knit = game:GetService("ReplicatedStorage")
    :WaitForChild("Packages")
    :WaitForChild("_Index")["sleitnick_knit@1.7.0"]
    :WaitForChild("knit")
    :WaitForChild("Services")

local CodeRemote = Knit.CodeService.RF.Redeem

-- [1] ระบบกรอก Code อัตโนมัติ
for _, code in ipairs({
    "200kInterestedBeast!",
    "subto_s3resutiaru!",
    "SmallUtopiaPatch!",
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

local Event = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.7.0"].knit.Services.DataService.RF.SetSelectionBannerMythic
Event:InvokeServer("Spade")
task.wait(0.5)

-- [2] ตั้งค่าระบบ Auto Sell และเคลมรางวัล
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

-- [3] ฟังก์ชันสำหรับการเช็คความแรร์และล้างคลัง (Bulk Sell)
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
        -- แก้ไขจาก && เป็น and เรียบร้อยแล้ว
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
            local args = { [1] = ListSeller }
            BulkSellRemote:FireServer(unpack(args))
        end
    end
end

-- [4] เริ่มลูปสุ่มตู้ Special
for i = 1, 11 do
    BuyBannerRemote:InvokeServer("FiftySummon", "Special")
    task.wait(0.5)
    RunSellScript()
    task.wait(3)
end

task.wait(1)

-- [5] เริ่มลูปสุ่มตู้ Universal2
for i = 1, 12 do
    BuyBannerRemote:InvokeServer("FiftySummon", "Universal2")
    task.wait(0.5)
    RunSellScript()
    task.wait(3)
end

-- [6] ระบบดึงข้อมูลคลัง (Inventory) ปัจจุบัน
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
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
    if not Inventory then
        local success, network = pcall(function() return require(ReplicatedStorage.Imported.network) end)
        if success and network and network.data and network.data.Inventory then
            Inventory = network.data.Inventory
        end
    end
    return Inventory
end

-- ลิสต์จัดลำดับความสำคัญยูนิต (Gohan, Sasuke อยู่ท้ายสุด)
local UNIT_PRIORITY = { 
    "GokuBlackUniversal",
    "Gogeta",
    "Spade",
    "Sabo",
    "GokuSSJ",
    "Kenpachi",
        "VegetaSSJ",
    "Sogeking",
    "Kriatu",
    "Shino",
    "Hades",
    "Fern",
    "Higuruma",
    "Sinbadr",
    "Buddha",
    "Gohan",                  
    "Sasuke"                  
}

local function CheckRuler(Guid)
    local Inv = GetCurrentInventory()
    if Inv then
        for _, v in pairs(Inv) do
            if tostring(v.GUID) == tostring(Guid) and v.Traits then
                for _, trait in pairs(v.Traits) do
                    if trait.Name == "Ruler" then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- ฟังก์ชันสำหรับจัดรูปแบบและส่ง Log ไปยังหน้า Panel
local function UpdateDescription()
    local debugUnit = "None"
    local checkbox = "❌"
    local Inventory = GetCurrentInventory()
    local foundTarget = false

    if Inventory then
        -- 1. หาตัวละครตามลำดับ Priority ก่อน
        for _, pName in ipairs(UNIT_PRIORITY) do
            for _, v in pairs(Inventory) do
                if v.UnitId == pName then
                    debugUnit = tostring(v.UnitId)
                    if CheckRuler(v.GUID) then
                        checkbox = "✅"
                    else
                        checkbox = "❌"
                    end
                    foundTarget = true
                    break
                end
            end
            if foundTarget then break end
        end

        -- 2. ถ้าไม่เจอในลิสต์ Priority ให้ดึงตัวแรร์ตัวแรกที่เจอในคลังมาโชว์แทน
        if not foundTarget then
            for _, v in pairs(Inventory) do
                if GetIsRare(v.UnitId) then
                    debugUnit = tostring(v.UnitId)
                    if CheckRuler(v.GUID) then
                        checkbox = "✅"
                    else
                        checkbox = "❌"
                    end
                    break
                end
            end
        end
    end

    local Gems = plr:GetAttribute("Gems") or 0
    local Reroll = plr:GetAttribute("Rerolls") or 0

    -- จัดรูปแบบข้อความ Log
    local messages = string.format("💎 Gems: %s, 🎲 Reroll: %s - %s : %s", tostring(Gems), tostring(Reroll), debugUnit, checkbox)

    if _G.Horst_SetDescription then
        _G.Horst_SetDescription(messages)
    else
        print("[Log Panel Updates]: " .. messages)
    end
end

-- [7] >>> ระบบสุ่มรีโรลหาบัพ RULER <<<
print("[+] เริ่มต้นระบบตรวจจับและสุ่มรีโรลหาบัพ Ruler...")

local function pickByPriority(units)
    for _, pName in ipairs(UNIT_PRIORITY) do
        for _, unit in ipairs(units) do
            if unit.name == pName then
                return { name = unit.name, uuid = unit.uuid }
            end
        end
    end
    return nil
end

-- เรียกใช้ครั้งแรกก่อนเริ่มลูปสุ่มเพื่ออัปเดตสถานะเริ่มต้น (โชว์ ❌ ไว้ก่อน)
pcall(UpdateDescription)

local checkRerollActive = true
while checkRerollActive do task.wait(0.5)
    local RerollPoints = plr:GetAttribute("Rerolls") or 0
    
    if RerollPoints >= 1 then
        local MythicList = {}
        local Inv = GetCurrentInventory()
        
        if Inv then
            for _, v in pairs(Inv) do
                if GetIsRare(v.UnitId) and v.GUID then
                    table.insert(MythicList, {
                        name = tostring(v.UnitId),
                        uuid = tostring(v.GUID)
                    })
                end
            end
        end

        local picked = pickByPriority(MythicList)

        if picked and picked.uuid and not CheckRuler(picked.uuid) then
            print("[🎲] กำลังรีโรลตัวละคร: " .. picked.name .. " | แต้มคงเหลือ: " .. tostring(RerollPoints))
            
            local args = { tostring(picked.uuid) }
            local success, result = game:GetService("ReplicatedStorage")
                :WaitForChild("Packages")
                :WaitForChild("_Index")["sleitnick_knit@1.7.0"]
                :WaitForChild("knit")
                :WaitForChild("Services")
                :WaitForChild("DataService")
                :WaitForChild("RF")
                :WaitForChild("Reroll")
                :InvokeServer(unpack(args))

            if typeof(success) == "table" then
                for _, v in pairs(success) do
                    if v.Name == "Ruler" then
                        print("[🎉 SUCCESS] ได้รับบัพ RULER บนตัว " .. picked.name .. " แล้ว!")
                        
                        -- ได้รับบัพปุ๊บ สั่งอัปเดตหน้าจอโชว์ติ๊กถูก ✅ ทันที
                        pcall(UpdateDescription)
                        
                        checkRerollActive = false
                        break
                    else
                        print("[-] ได้บัพ: " .. tostring(v.Name) .. " (กำลังสุ่มต่อ...)")
                    end
                end
            end
        elseif picked and CheckRuler(picked.uuid) then
            print("[🎉] ตัวละครเป้าหมายมีบัพ Ruler เรียบร้อยแล้ว สั่งหยุดทำงาน!")
            
            -- มีบัพอยู่แล้วตั้งแต่แรก สั่งอัปเดตหน้าจอโชว์ติ๊กถูก ✅ ทันที
            pcall(UpdateDescription)
            
            checkRerollActive = false
        else
            print("[-] ไม่พบยูนิตเพิ่มในรายการจัดลำดับความสำคัญ หรือติด Ruler ครบถ้วนแล้ว")
            checkRerollActive = false
        end
    else
        print("[-] แต้มรีโรลหมดเกลี้ยงแล้ว!")
        checkRerollActive = false
    end
end

-- [8] บังคับรันคำสั่งอัปเดตค่าไปยังหน้าต่าง UI ขั้นสุดท้าย และเคลียร์ Account ทันที
task.wait(0.5)
pcall(UpdateDescription)

-- เคลียร์ไอดีเปลี่ยนหน้าบอท
if _G.Horst_AccountChangeDone then
    _G.Horst_AccountChangeDone()
end

print("[🎉] สคริปต์ทำงานเสร็จสมบูรณ์!")
