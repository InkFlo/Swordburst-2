--[[
    Swordburst 2 GUI

    By Spencer#0003

    Since creating this script, I've noticed that I've attracted the attention of a fucking retard named Wally.

    1. https://sperg.club/uploads/Ave8juZmTTPHr7tX.png
    Stolen an idea of DC's then bitches when I copy it too, fucking hypocrite.

    2. https://sperg.club/uploads/70lakQGPmIIPKUIn.png
    This script is nowhere near as good as DC's paid one you fucking ape.
]]

-- Init

local getupvalue = getupvalue or debug.getupvalue;

local httpService = game:GetService("HttpService");
local players = game:GetService("Players");
local replicatedStorage = game:GetService("ReplicatedStorage");
local tweenService = game:GetService("TweenService");
local starterGui = game:GetService("StarterGui");
local client = players.LocalPlayer;

local runService = game:GetService("RunService");
local heartbeat = runService.heartbeat;

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/LegoHacks/Utilities/main/UI.lua"))();
local moderators = game:HttpGet("https://raw.githubusercontent.com/LegoHacks/Swordburst-2/main/Moderators.txt"):split("\n");

-- Main Script

local mobs = {
    [542351431] = {
        "Bear";
        "Draconite";
        "Frenzy Boar";
        "Hermit Crab";
        "Ruin Knight";
        "Ruin Kobold Knight";
        "Wolf";
    };

    [548231754] = {
        "Bushback Tortoise";
        "Leaf Beetle";
        "Leaf Ogre";
        "Leafray";
        "Pearl Keeper";
        "Wasp";
    };

    [555980327] = {
        "Angry Snowman";
        "Ice Elemental";
        "Icewhal";
        "Ice Walker";
        "Snowgre";
        "Snowhorse";
    };

    [572487908] = {
        "Bamboo Spider";
        "Bamboo Spiderling";
        "Birchman";
        "Boneling";
        "Dungeon Dweller";
        "Lion Protector";
        "Treeray";
        "Wattlechin Crocodile";
    };

    [580239979] = {
        "Angry Cactus";
        "Desert Vulture";
        "Girdled Lizard";
        "Giant Centipede";
        "Sand Scorpion";
    };

    [582198062] = {
        "Blightmouth.";
        "Firefly";
        "Gloom Shroom";
        "Horned Sailfin Iguana";
        "Jelly Wisp";
        "Shroom Back Clam";
        "Snapper";
    };
    
    [548878321] = {
        "Giant Praying Mantis";
        "Petal Knight";
        "Leaf Rhino";
        "Sky Raven";
        "Forest Wanderer";
        "Wingless Hippogriff";
        "Dungeon Crusador";
    };

    [573267292] = {
        "Batting Eye";
        "Ent";
        "Enraged Lingerer";
        "Fishrock Spider";
        "Lingerer";
        "Reptasaurus";
        "Undead Warrior";
        "Undead Berserker";
    };

    [2659143505] = {
        "Grunt";
        "Guard Hound";
        "Minion";
        "Shady Villager";
        "Undead Servant";
        "Winged Minion";
        "Wendigo";
    };

    [5287433115] = {
        "Command Falcon";
        "Reaper";
        "Shadow Figure";
        "Soul Eater";
        "???????";
    };

    [6144637080] = { -- Winter event
        "Evergreen Sentinel";
        "Crystalite";
        "Gemulite";
        "Icy Imp";
    };
};

local bosses = {
    [542351431] = {
        "Dire Wolf";
        "Rahjin the Thief King";
    };

    [548231754] = {
        "Borik the BeeKeeper";
        "Gorrock the Grove Protector";
    };

    [555980327] = {
        "Ra'thae the Ice King";
        "Qerach The Forgotten Golem";
    };

    [572487908] = {
        "Irath the Lion";
        "Rotling";
    };

    [580239979] = {
        "Fire Scorpion";
        "Sa'jun the Centurian Chieftain";
    };
    
    [582198062] = {
        "Frogazoid";
        "Smashroom";
    };

    [548878321] = {
        "Hippogriff";
        "Formaug the Jungle Giant";
    };

    [573267292] = {
        "Gargoyle Reaper";
        "Mortis the Flaming Sear";
        "Polyserpant";
    };

    [2659143505] = {
        "Baal";
        "Grim the Overseer";
    };

    [5287433115] = {
        "Da";
        "Ra";
        "Ka";
    };

    [6144637080] = { -- Winter event
        "Wintula the Punisher";
    };
};


local function getClosestMob()
    local distance, mob = math.huge;
    for i, v in next, workspace.Mobs:GetChildren() do
        if (v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Nameplate") and v.PrimaryPart and v.Parent and v:FindFirstChild("Entity") and v.Entity.Health.Value > 0) then
            if (library.flags.bosses) then
                for a, b in next, bosses[game.PlaceId] do
                    if (b == v.Name) then
                        return v;
                    end;
                end;
            end;

            local distanceFromChar = client:DistanceFromCharacter(v.HumanoidRootPart.Position);
            if (distanceFromChar < distance) then
                if (library.flags.chosen_mob and v.Name == library.flags.chosen_mob or library.flags.aura) then
                    distance = distanceFromChar;
                    mob = v;
                end;
            end;
        end;
    end;

    return mob;
end;

local function getSkill()
    local skill;

    local left = replicatedStorage.Profiles[client.Name].Equip.Left.Value;
    local right = replicatedStorage.Profiles[client.Name].Equip.Right.Value;

    if (left ~= 0 and right ~= 0) then
        skill = "Whirlwind Spin";
    else
        local inventoryId = (left == 0 and right or right == 0 and left);
        local itemName, itemType;

        for i, v in next, replicatedStorage.Profiles[client.Name].Inventory:GetChildren() do
            if (v.Value == inventoryId) then
                itemName = v.Name;
                break;
            end;
        end;

        local item = replicatedStorage.Database.Items:FindFirstChild(itemName);

        if (item) then
            itemType = item:FindFirstChild("Class") and item.Class.Value;
        end;

        if (itemType and itemType == "1HSword") then
            skill = "Sweeping Strike";
        elseif (itemType and itemType == "2HSword") then
            skill = "Downward Smash"
        elseif (itemType and itemType == "Katana") then
            skill = "Leaping Slash";
        else
            skill = "Piercing Dash";
        end;
    end;

    return skill;
end;

local skill = getSkill();

local oldDelay = getrenv().delay;
getrenv().delay = function(...)
    if (library.flags.instant_trade) then
        return;
    end;

    return oldDelay(...);
end;

local services, crystalForge; do
    repeat
        for i, v in next, getreg() do
            if (typeof(v) == "table" and rawget(v, "Services")) then
                services = v.Services;
            elseif (typeof(v) == "table" and rawget(v, "Craft")) then
                crystalForge = v;
            end;

            if (services and crystalForge) then break end;
        end;

        heartbeat:Wait();
    until services and crystalForge;
end;

local rpcKey = getupvalue(services.Combat.Init, 2);

local function attack(target)
    for i = 1, library.flags.attack_speed do
        replicatedStorage.Event:FireServer("Skills", {"UseSkill", skill});
        replicatedStorage.Event:FireServer("Combat", rpcKey, {"Attack", skill, 1, target});
    end;
end;

for i, v in next, players:GetPlayers() do
    if (moderators[tostring(v.UserId)]) then
        return client:Kick("\n[Moderator Detected]\n" .. v.Name);
    end;
end;

players.PlayerAdded:Connect(function(player)
    if (moderators[tostring(player.UserId)]) then
        return client:Kick("\n[Moderator Detected]\n" .. player.Name);
    end;
end);

starterGui:SetCore("SendNotification", {
	Title = "Notice";
	Text = "Got any mods to add to the mod detector?\nDM me on Discord: Spencer#0003";
	Duration = 5;
});

spawn(function()
    for i, v in next, moderators do
        if (v ~= "") then
            local res = httpService:JSONDecode(game:HttpGet("https://api.roblox.com/users/" .. v .. "/onlinestatus/"));
            if (res.IsOnline) then
                starterGui:SetCore("SendNotification", {
                    Title = "Notice";
                    Text = players:GetNameFromUserIdAsync(v) .. " is online, be careful!";
                    Duration = 5;
                });
            end;
        end;
    end;
end);

if (getconnections) then
    for i, v in next, getconnections(client.Idled) do
        v:Disable();
    end;
else
    local vu = game:GetService("VirtualUser");
    client.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
        wait(1);
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame);
    end);
end;

local autoFarmTab = library:CreateWindow("Auto Farm");

autoFarmTab:AddToggle({
    text = "Enabled";
    flag = "autofarming"
});

autoFarmTab:AddToggle({
    text = "Kill Aura";
    flag = "aura"
});

autoFarmTab:AddToggle({
    text = "Prioritise Bosses";
    flag = "bosses"
});

autoFarmTab:AddSlider({
    text = "Attack Speed";
    flag = "attack_speed";
    min = 1;
    max = 100;
});

autoFarmTab:AddList({
    text = "Chosen Mob";
    flag = "chosen_mob";
    values = mobs[game.PlaceId];
});

local miscTab = library:CreateWindow("Misc Cheats");

miscTab:AddToggle({
    text = "Instant Trade";
    flag = "instant_trade";
});

miscTab:AddToggle({
    text = "WalkSpeed";
    flag = "walkspeed_enabled";
});

miscTab:AddSlider({
    text = "Speed";
    flag = "chosen_speed";
    min = 16;
    max = 80;
});

miscTab:AddButton({
    text = "Go Invisible";
    callback = function()
        if (client.Character and client.Character:FindFirstChild("LowerTorso")) then
            local root = client.character.LowerTorso.Root:Clone();
            client.character.LowerTorso.Root:Destroy();
            root.Parent = client.character.LowerTorso;
        end;
    end;
});

local itemTab = library:CreateWindow("Items");

itemTab:AddList({
    text = "Item";
    flag = "chosen_item";
    values = replicatedStorage.Profiles[client.Name].Inventory:GetChildren();
});

itemTab:AddButton({
    text = "Dismantle";
    callback = function()
        replicatedStorage.Event:FireServer("Equipment", {"Dismantle", replicatedStorage.Profiles[client.Name].Inventory:FindFirstChild(library.flags.chosen_item)});
    end;
});

itemTab:AddButton({
    text = "Upgrade";
    callback = function()
        replicatedStorage.Event:FireServer("Equipment", {"Upgrade", replicatedStorage.Profiles[client.Name].Inventory:FindFirstChild(library.flags.chosen_item)});
    end;
});

itemTab:AddSlider({
    text = "Crystals";
    flag = "chosen_crystals";
    min = 1;
    max = 100;
});

itemTab:AddButton({
    text = "Rare Crystal";
    callback = function()
        for i = 1, library.flags.chosen_crystals do
            crystalForge:Craft("Legendary Upgrade Crystal");
        end;
    end;
});

itemTab:AddButton({
    text = "Legendary Crystal";
    callback = function()
        for i = 1, library.flags.chosen_crystals do
            crystalForge:Craft("Legendary Upgrade Crystal");
        end;
    end;
});

local skillTab = library:CreateWindow("Skills");
skillTab:AddList({
    text = "Chosen Skill";
    flag = "chosen_skill";
    values = {"Summon Pistol", "Summon Tree", "Infinity Slash"};
});

skillTab:AddButton({
    text = "Unlock Skill";
    callback = function()
        if (not replicatedStorage.Profiles[client.Name].Skills:FindFirstChild(library.flags.chosen_skill)) then
            local Skill = Instance.new("StringValue");
            Skill.Parent = replicatedStorage.Profiles[client.Name].Skills;
            Skill.Name = library.flags.chosen_skill;
        end;
    end;
});

heartbeat:Connect(function()
    if (client.Character and library.flags.autofarming) then
        for i, v in next, client.Character:GetChildren() do
            if (v:IsA("BasePart")) then
                v.CanCollide = false;
            end;
        end;
    end;
end);

spawn(function()
    while true do
        if (library.flags.autofarming) then
            local mob = getClosestMob();

            if (mob) then
                pcall(function()
                    client.Character.Humanoid:ChangeState(11);
                    tweenService:Create(client.Character.HumanoidRootPart, TweenInfo.new(((client.Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position)).magnitude / 40), {CFrame = mob.PrimaryPart.CFrame * CFrame.new(0, 20, 0)}):Play();
                end);
            end;
        end;
        wait();
    end;
end);

spawn(function()
    while true do
        if (library.flags.autofarming or library.flags.aura) then
            local mob = getClosestMob();

            if (mob and mob:FindFirstChild("HumanoidRootPart") and mob.HumanoidRootPart and (client.Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).magnitude <= 60) then
                repeat
                    attack(mob);
                    wait(0.15);
                until not mob or not mob:FindFirstChild("Nameplate") or not mob:FindFirstChild("Healthbar") or not mob:FindFirstChild("Entity");
            end;
        end;

        if (client.Character and client.Character:FindFirstChild("Humanoid")) then
            client.Character.Humanoid.WalkSpeed = (library.flags.walkspeed_enabled and library.flags.chosen_speed or 16);
        end;
        wait();
    end;
end);

library:Init();
