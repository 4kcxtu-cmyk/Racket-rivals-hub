-- Racket Rivals Hub | Key: XoX!
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- === KEY SYSTEM (BLOCKS SCRIPT UNTIL CORRECT KEY) ===
local Key = "XoX!"

local function LoadHub()
   local Window = Rayfield:CreateWindow({
      Name = "Racket Rivals Hub",
      LoadingTitle = "Racket Rivals",
      LoadingSubtitle = "by Grok",
      ConfigurationSaving = { Enabled = true, FolderName = "RacketRivalsHub" }
   })

   local PlayerTab = Window:CreateTab("Player")
   local MovementTab = Window:CreateTab("Movement")
   local CombatTab = Window:CreateTab("Combat")
   local VisualsTab = Window:CreateTab("Visuals")
   local TeleportTab = Window:CreateTab("Teleport")
   local MiscTab = Window:CreateTab("Misc")

   -- [PLAYER]
   PlayerTab:CreateToggle({ Name = "Infinite Jump", Callback = function(v)
      if v then
         game:GetService("UserInputService").JumpRequest:Connect(function()
            game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
         end)
      end
   end})

   PlayerTab:CreateToggle({ Name = "No Clip", Callback = function(v)
      local c; if v then c = game:GetService("RunService").Stepped:Connect(function()
         for _, p in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
         end
      end) else if c then c:Disconnect() end end
   end})

   PlayerTab:CreateToggle({ Name = "God Mode", Callback = function(v)
      if v and game.Players.LocalPlayer.Character then
         local h = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
         if h then h.MaxHealth, h.Health = math.huge, math.huge end
      end
   end})

   -- [MOVEMENT]
   MovementTab:CreateSlider({ Name = "Walk Speed", Range = {16, 500}, Increment = 1, CurrentValue = 16,
      Callback = function(v) pcall(function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end) end
   })

   MovementTab:CreateSlider({ Name = "Jump Power", Range = {50, 500}, Increment = 1, CurrentValue = 50,
      Callback = function(v) pcall(function() game.Players.LocalPlayer.Character.Humanoid.JumpPower = v end) end
   })

   MovementTab:CreateToggle({ Name = "Fly", Callback = function(v)
      local c, bv, ba; local p = game.Players.LocalPlayer
      if v and p.Character then
         local r = p.Character:FindFirstChild("HumanoidRootPart")
         if not r then return end
         bv = Instance.new("BodyVelocity", r); bv.MaxForce = Vector3.new(4e4,4e4,4e4)
         ba = Instance.new("BodyAngularVelocity", r); ba.MaxTorque = Vector3.new(4e4,4e4,4e4)
         c = game:GetService("RunService").Heartbeat:Connect(function()
            bv.Velocity = p.Character.Humanoid.MoveDirection.Magnitude > 0 and r.CFrame.LookVector * 50 or Vector3.new()
         end)
      else
         if c then c:Disconnect() end
         if bv then bv:Destroy() end
         if ba then ba:Destroy() end
      end
   end})

   -- [COMBAT]
   CombatTab:CreateToggle({ Name = "Aimbot (Ball Lock)", Callback = function(v)
      local c
      if v then
         c = game:GetService("RunService").Heartbeat:Connect(function()
            local char = game.Players.LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local ball = workspace:FindFirstChild("Ball")
            if ball and ball:IsA("BasePart") then
               char.HumanoidRootPart.CFrame = CFrame.lookAt(char.HumanoidRootPart.Position, ball.Position)
            end
         end)
      else if c then c:Disconnect() end end
   end})

   CombatTab:CreateButton({ Name = "Auto Hit Ball", Callback = function()
      local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
      if tool then tool:Activate() end
   end})

   -- [VISUALS]
   VisualsTab:CreateToggle({ Name = "Player ESP", Callback = function(v)
      local c
      if v then
         c = game:GetService("RunService").Heartbeat:Connect(function()
            for _, plr in pairs(game.Players:GetPlayers()) do
               if plr ~= game.Players.LocalPlayer and plr.Character then
                  local hl = plr.Character:FindFirstChild("ESPHighlight") or Instance.new("Highlight", plr.Character)
                  hl.Name, hl.FillColor, hl.OutlineColor = "ESPHighlight", Color3.fromRGB(255,0,0), Color3.fromRGB(255,255,255)
               end
            end
         end)
      else
         if c then c:Disconnect() end
         for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Character then
               local hl = plr.Character:FindFirstChild("ESPHighlight")
               if hl then hl:Destroy() end
            end
         end
      end
   end})

   VisualsTab:CreateToggle({ Name = "Fullbright", Callback = function(v)
      local l = game.Lighting
      if v then
         l.Brightness = 2; l.ClockTime = 14; l.FogEnd = 1e5; l.GlobalShadows = false
      else
         l.Brightness = 1; l.ClockTime = 12; l.FogEnd = 100; l.GlobalShadows = true
      end
   end})

   -- [TELEPORT]
   TeleportTab:CreateButton({ Name = "Spawn", Callback = function()
      pcall(function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,5,0) end)
   end})

   TeleportTab:CreateButton({ Name = "Court 1", Callback = function()
      pcall(function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(100,5,0) end)
   end})

   TeleportTab:CreateButton({ Name = "Court 2", Callback = function()
      pcall(function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-100,5,0) end)
   end})

   -- [MISC]
   MiscTab:CreateButton({ Name = "Rejoin", Callback = function()
      game:GetService("TeleportService"):Teleport(game.PlaceId)
   end})

   MiscTab:CreateButton({ Name = "Server Hop", Callback = function()
      local s = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
      game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s[math.random(#s)].id)
   end})

   MiscTab:CreateButton({ Name = "Disconnect", Callback = function()
      game.Players.LocalPlayer:Kick("Disconnected via Script Hub")
   end})

   Rayfield:Notify({ Title = "Loaded!", Content = "Key Accepted: XoX! | Enjoy!", Duration = 5 })
end

-- === PROPER KEY VALIDATION ===
Rayfield:CreateKeySystem({
   Title = "Racket Rivals Key System",
   Subtitle = "Enter Key to Unlock",
   Note = "Key: XoX!",
   SaveKey = true,
   Key = Key,
   Callback = function(input)
      if input == Key then
         LoadHub()
      else
         Rayfield:Notify({ Title = "Invalid Key", Content = "Wrong key! Try again.", Duration = 3 })
      end
   end
})
