_,MUI=...

MUI.bigS=45
MUI.medS=30
MUI.smallS=20
MUI.bigFS=24
MUI.medFS=18
MUI.smallFS=13

local tempF=CreateFrame("Frame")
tempF:RegisterEvent("PLAYER_ENTERING_WORLD")
tempF:SetScript("OnEvent",function()
  local className=UnitClass("player")
  if className~="Monk" then return
  else
    tempF:UnregisterEvent("PLAYER_ENTERING_WORLD")
    tempF=nil
    local fabn=AuraUtil.FindAuraByName
    local green={0.3,0.95,0.3}
    local red={0.9,0.3,0.3}

    local manaBD={edgeFile ="Interface\\DialogFrame\\UI-DialogBox-Border",edgeSize = 8, insets ={ left = 0, right = 0, top = 0, bottom = 0 }}
    local bd2={edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 10, insets = { left = 4, right = 4, top = 4, bottom = 4 }}
    local insert=table.insert
    local port={}
    local mf=math.floor
    local afterDo=C_Timer.After
    local pairs=pairs
    local playerName=UnitName("player")
    
    function MUI.onCast1(self)
      local t,d=GetSpellCooldown(self.id)
      if d<2 then
        self.offCD:Show()
        self.onCD:Hide()
      else
        self.offCD:Hide()
        self.onCD:Show()
        self.onCD.et=1
        self.onCD.cd:SetCooldown(t,d)
        self.onCD.t=t
        self.onCD.d=d
      end
    end

    function MUI.onCastEF(self)
      local t,d=GetSpellCooldown(self.id)

      if d<2 then
        self.offCD:Show()
        self.onCD:Hide()
      else
        self.offCD:Hide()
        self.onCD:Show()
        self.onCD.et=1
        self.onCD.cd:SetCooldown(t,d)
        self.onCD.t=t
        self.onCD.d=d
      end

      local _,_,_,_,channelEndTime=UnitChannelInfo("player")
      if not channelEndTime then return end
      local ticks=(channelEndTime-GetTime()*1000+1500)/4000
      afterDo(ticks,function() port[116680]:onCast() end)
      afterDo(ticks*2,function() port[116680]:onCast() end)
      afterDo(ticks*3,function() port[116680]:onCast() end)
      afterDo(ticks*3.5,function() port[116680]:onCast() end)
      afterDo(ticks*4,function() port[116680]:onCast() end)
   
    end
    
    function MUI.onCastTFT(self)
      local t,d=GetSpellCooldown(self.id)
      if d<2 then
        self.offCD:Show()
        self.onCD:Hide()
        if t>0 then
          local s=select(3,fabn("Thunder Focus Tea","player"))
          self.stacks:SetText(s)
        else
          self.stacks:SetText("")
        end
        
      else
        self.offCD:Hide()
        self.onCD:Show()
        self.onCD.et=1
        self.onCD.cd:SetCooldown(t,d)
        self.onCD.t=t
        self.onCD.d=d
      end

    end
    
    function MUI.onCastDetox(self)
      local oc=MUI.onCast1
      afterDo(0,function() oc(self) end)
      afterDo(0.05, function() oc(self) end)
      afterDo(0.1, function() oc(self) end)
    end

    function MUI.onCastReM(self)
      --local t,d=GetSpellCooldown(self.id)
      local s,_,t,d=GetSpellCharges(self.id)

      if s==2 then
        self.onCD:Hide()
        self.offCD:Show()
        self.offCD.et=1
        self.offCD.cd:SetCooldown(0,0)
        self.offCD.t=t
        self.offCD.d=d
        self.offCD.text2:SetText(s)
      elseif s>0 and d>2 then
        self.onCD:Hide()
        self.offCD:Show()
        self.offCD.et=1
        self.offCD.cd:SetCooldown(t,d)
        self.offCD.t=t
        self.offCD.d=d
        self.offCD.text2:SetText(s)
        afterDo(d, function() self:onCast() end)
      elseif s==0 then
        self.offCD:Hide()
        self.onCD:Show()
        self.onCD.et=1
        self.onCD.cd:SetCooldown(t,d)
        self.onCD.t=t
        self.onCD.d=d
      end
      
    end

    function MUI.onCastDetox(self)
      local oc=MUI.onCast1
      afterDo(0,function() oc(self) end)
      afterDo(0.05, function() oc(self) end)
      afterDo(0.1, function() oc(self) end)
    end
    
    local nBoK=8
    function MUI.onCastBoK(self)

      for i=1,nBoK+1 do
        afterDo((i-1)/nBoK,function() port[107428]:onCast() end)
      end
      port[100780]:onCast()
    end

    local function applyTOTM(s)
      local totm=MUI.totm
      if not s then s=0  end
      totm.normal.text:SetText(s)
      if s>0 then totm.normal:Show(); totm.grey:Hide() else totm.grey:Show(); totm.normal:Hide() end
    end

    function MUI.jSSCheck(self)
      local up=GetTotemInfo(1)
      if up then 
        self.normal:Show(); self.grey:Hide() 
        if self.channeling then
          self.channelUp:Show()
          self.channelDown:Hide()      
        else
          self.channelDown:Show()
          self.channelUp:Hide()      
        end
        
      else self.grey:Show(); self.normal:Hide() end
      
    end
    
    function MUI.jSSCheckLite(self)
      local up=GetTotemInfo(1)
      if up then 
        self.normal:Show(); self.grey:Hide()         
      else 
        self.grey:Show(); self.normal:Hide()
        self.unit=nil
        self.channeling=false
      end       
    end
    
    function MUI.onCastTP(self)
      local fabn=AuraUtil.FindAuraByName
      local nm=MUI.totm.normal
      --local s=select(9,fabn("player","Teachings of the Monastery"))
      afterDo(0,function() local s=select(3,fabn("Teachings of the Monastery","player"));applyTOTM(s) end )
      afterDo(0.1,function() local s=select(3,fabn("Teachings of the Monastery","player"));applyTOTM(s) end )
      afterDo(0.2,function() local s=select(3,fabn("Teachings of the Monastery","player"));applyTOTM(s) end )
      MUI.totm.ext=GetTime()+19.8
      afterDo(20,function() MUI.totm:check()  end)
      nm.cd:SetCooldown(GetTime(),20)
    end

    function MUI.onUpdate1(self,et)
      self.et=self.et+et
      if self.et<0.1 then return end

      self.et=0
      local rT=self.t+self.d-GetTime()
      self.text1:SetText(mf(rT))
      if rT<0.01 then self.parent:onCast() end
    end
    
    function MUI.onUpdateJSSChannelUp(self,et)
      self.et=self.et+et
      if self.et<0.1 then return end

      self.et=0
      local rT=self.t+self.d-GetTime()
      self.text:SetText(mf(rT))    
    end
    
    local function createCDIcon(id,size)
      local iF
      local _,_,icon=GetSpellInfo(id)
      local s,fs
      if size=="big" then s=MUI.bigS; fs=MUI.bigFS end
      if size=="med" then s=MUI.medS; fs=MUI.medFS end
      if size=="small" then s=MUI.smallS; fs=MUI.smallFS end

      iF=CreateFrame("Frame",nil,MUI.f)
      iF:SetSize(s,s)
      iF:SetFrameLevel(5)
      iF.id=id
      
      iF.offCD=CreateFrame("Frame",nil,iF)
      iF.offCD:SetAllPoints(true)

      iF.offCD.texture=iF.offCD:CreateTexture(nil,"BACKGROUND")
      iF.offCD.texture:SetAllPoints(true)
      iF.offCD.texture:SetTexture(icon)

      iF.offCD.cd=CreateFrame("Cooldown",nil,iF.offCD,"CooldownFrameTemplate")
      iF.offCD.cd:SetAllPoints(true)
      iF.offCD.cd:SetFrameLevel(iF.offCD:GetFrameLevel())
      iF.offCD.cd:SetDrawEdge(false)
      iF.offCD.cd:SetDrawBling(false)
      
      iF.offCD.text2=iF.offCD:CreateFontString(nil,"OVERLAY")
      iF.offCD.text2:SetFont("Fonts\\FRIZQT__.ttf",fs,"OUTLINE")
      iF.offCD.text2:SetPoint("CENTER")
      
      iF.onCD=CreateFrame("Frame",nil,iF)
      iF.onCD:SetAllPoints(true)
      
      iF.onCD.texture=iF.onCD:CreateTexture(nil,"BACKGROUND")
      iF.onCD.texture:SetAllPoints(true)
      iF.onCD.texture:SetTexture(icon)
      iF.onCD.texture:SetDesaturated(1)

      iF.onCD.cd=CreateFrame("Cooldown",nil,iF.onCD,"CooldownFrameTemplate")
      iF.onCD.cd:SetAllPoints(true)
      iF.onCD.cd:SetFrameLevel(iF.onCD:GetFrameLevel())
      iF.onCD.cd:SetDrawEdge(false)
      iF.onCD.cd:SetDrawBling(false)
      
      iF.onCD.text1=iF.onCD:CreateFontString(nil,"OVERLAY")
      iF.onCD.text1:SetFont("Fonts\\FRIZQT__.ttf",fs,"OUTLINE")
      iF.onCD.text1:SetPoint("CENTER")

      iF.onCD:SetScript("OnUpdate",MUI.onUpdate1)
      iF.onCD.parent=iF

      iF.onCD:Hide()

      iF.onCD.et=0
      port[id]=iF
      return iF
    end
    
    local function createAuraIcon(id,size)
      local iF
      local _,_,icon=GetSpellInfo(id)
      local s,fs
      if size=="big" then s=MUI.bigS; fs=MUI.bigFS end
      if size=="med" then s=MUI.medS; fs=MUI.medFS end
      if size=="small" then s=MUI.smallS; fs=MUI.smallFS end

      iF=CreateFrame("Frame",nil,MUI.f)
      iF:SetSize(s,s)
      iF:SetFrameLevel(5)
      iF.id=id
      
      iF.grey=CreateFrame("Frame",nil,iF)
      iF.grey:SetAllPoints(true)

      iF.grey.texture=iF.grey:CreateTexture(nil,"BACKGROUND")
      iF.grey.texture:SetAllPoints(true)
      iF.grey.texture:SetTexture(icon)
      iF.grey.texture:SetDesaturated(1)

      iF.grey.text=iF.grey:CreateFontString(nil,"OVERLAY")
      iF.grey.text:SetFont("Fonts\\FRIZQT__.ttf",fs,"OUTLINE")
      iF.grey.text:SetPoint("CENTER")
      
      iF.normal=CreateFrame("Frame",nil,iF)
      iF.normal:SetAllPoints(true)
      
      iF.normal.texture=iF.normal:CreateTexture(nil,"BACKGROUND")
      iF.normal.texture:SetAllPoints(true)
      iF.normal.texture:SetTexture(icon)

      iF.normal.cd=CreateFrame("Cooldown",nil,iF.normal,"CooldownFrameTemplate")
      iF.normal.cd:SetAllPoints(true)
      iF.normal.cd:SetFrameLevel(iF.normal:GetFrameLevel())

      iF.normal.text=iF.normal:CreateFontString(nil,"OVERLAY")
      iF.normal.text:SetFont("Fonts\\FRIZQT__.ttf",fs,"OUTLINE")
      iF.normal.text:SetPoint("CENTER")

      iF.normal:Hide()

      iF.normal.et=0
      return iF
    end

    local function checkTalentStuff()
      local _,_,_,mT = GetTalentInfo(3,3,1)
      local _,_,_,rJW = GetTalentInfo(6,2,1)
      local _,_,_,cJ = GetTalentInfo(6,3,1)
      local _,_,_,jSS=GetTalentInfo(6,1,1)
      --if mT then  MUI.mT:Show(); MUI.mT:onCast() else MUI.mT:Hide() end
      MUI.mT:Show()
      if rJW then MUI.rJW:Show(); MUI.rJW:onCast() else MUI.rJW:Hide() end
      if cJ then MUI.cJ:Show(); MUI.cJ:onCast() else MUI.cJ:Hide() end 
      if jSS then MUI.jSS:Show(); MUI.jSS:check(); else MUI.jSS:Hide() end
    end

    local function checkCombat()
        if true then return  end
        if InCombatLockdown() then MUI.f:Show() else MUI.f:Hide() end 
    end
    
    local function checkSpecialization()
      
      if GetSpecialization()==2 then MUI.f:Show(); MUI.f.loaded=true; else MUI.f:Hide(); MUI.f.loaded=false; end
      checkCombat()
    end
    
    local function fOnShow()
      for _,v in pairs(port) do  v:onCast() end
      MUI.mana:update()
    end
       
    local function hasJSS(unit)
      if not unit then return nil end
      local d,t
      for i=1,40 do
        
        local name,_,_,_,_,_,_,_,_,ID=UnitAura(unit,i,"PLAYER")
        if not name then return nil end
        if ID==198533 then 
          return true
        end 
      end     
    end
    
    local function getUnitID(name)
      local raid=IsInRaid()
      local s=""
      local n=GetNumGroupMembers()
      if raid then
        s="raid"
      else
        if UnitName("player")==name then return "player" end
        s="party"
        n=n-1
      end
      
      for i=1,n do
        local s2=s..tostring(i)
        local un,ur=UnitName(s2)
        if ur then un=un.."-"..ur end
        if un==name then return s2 end
      end
      return nil      
    end
    
    MUI.eventHandler = function(self,event,_,tar,id,id2)

      if event=="UNIT_POWER_UPDATE" then 
        MUI.mana:update()
        
        
      elseif event=="UNIT_SPELLCAST_SUCCEEDED" then
       local spell=port[id]
       if spell then afterDo(0,function() spell:onCast(); port[116680]:onCast() end) 
       else afterDo(0,function() port[116680]:onCast() end) end --TFT (116680) because it can be influenced by so many spells, no point to add conditionals 
       --if id==585 then afterDo(0,function() port[47540]:onCast() end) end
      
      elseif event=="UNIT_SPELLCAST_SENT" then
        if id2~=115175 then return end
        local unit=getUnitID(tar)

        if not unit then return end --TARGET IS NOT IN PARTY
        
        local castTime=GetTime()
        local duration=3000/(100+UnitSpellHaste("player"))
        
        afterDo(0,function()
          if not hasJSS(unit) then return end 
          local f=MUI.jSS.channelUp
          local jSS=MUI.jSS
          jSS.channeling=true
          
          if unit~=jSS.unit then
            jSS.unit=unit
            jSS:UnregisterEvent("UNIT_AURA")
            jSS:RegisterUnitEvent("UNIT_AURA",unit)
            f.d=duration
          else
            local maxDuration=3000/(100+UnitSpellHaste("player"))*1.3
            f.d=math.min(duration+f.d,maxDuration)
          end
          
          f.t=castTime

          f.et=10
          jSS:check()
        end)
        
      end       
    end

    local function checkTOTM(self)
      if GetTime()>self.ext then self.normal:Hide(); self.grey:Show() end
    end
    
    local function onCastJSS()
      MUI.jSS:check()   
    end
    
    MUI.f=CreateFrame("Frame","MUIFrame",UIParent)
    local f=MUI.f


    --main frame + mover + slash command
    do
    f:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED","player")
    f:RegisterEvent("UNIT_SPELLCAST_SENT")
    f:RegisterUnitEvent("UNIT_POWER_UPDATE","player")
    f:SetScript("OnEvent",MUI.eventHandler)
    f:SetScript("OnShow",fOnShow)
    f:SetSize(2*MUI.bigS+1,150)
    f:SetPoint("CENTER")
    f:SetMovable(true)

    f.mover=CreateFrame("Frame",nil,f)
    f.mover:SetAllPoints(true)
    f.mover:SetFrameLevel(f:GetFrameLevel()+6)

    f.mover.texture=f.mover:CreateTexture(nil,"OVERLAY")
    f.mover.texture:SetAllPoints(true)
    f.mover.texture:SetColorTexture(0,0,0.1,0.5)

    f.mover:EnableMouse(true)
    f.mover:SetMovable(true)
    f.mover:RegisterForDrag("LeftButton")
    f.mover:SetScript("OnMouseDown", function() MUI.f:StartMoving();  end)
    f.mover:SetScript("OnMouseUp", function() MUI.f:StopMovingOrSizing();  end)
    f.mover:Hide()

    SLASH_MUI1="/mui"
    SlashCmdList["MUI"]= function(arg)
      if f.mover:IsShown() then f.mover:Hide() else f.mover:Show() end
    end

    end --end of main mover slash

    --helper frame
    do
    MUI.h=CreateFrame("Frame","MUIHFrame",UIParent)
    local h=MUI.h
    h:SetPoint("CENTER")
    h:SetSize(1,1)
    h:RegisterEvent("PLAYER_REGEN_ENABLED")
    h:RegisterEvent("PLAYER_REGEN_DISABLED")
    h:RegisterEvent("PLAYER_ENTERING_WORLD")
    h:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    h:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    
    local function hEventHandler(self,event) 
      if event=="PLAYER_REGEN_ENABLED" then
        afterDo(15,checkCombat)
      elseif event=="PLAYER_REGEN_DISABLED" then
        if MUI.f.loaded then MUI.f:Show() end
      elseif event=="ACTIVE_TALENT_GROUP_CHANGED" then
        checkTalentStuff()
      elseif event=="PLAYER_SPECIALIZATION_CHANGED" then
        checkSpecialization()
      end
    end

    h:SetScript("OnEvent",hEventHandler)

    end --end of help frame

    --spells 
    do 

    MUI.eF=createCDIcon(191837,"big")
    MUI.eF:SetPoint("TOPLEFT",MUI.f,"TOPLEFT",1+MUI.bigS,0)
    MUI.eF.onCast=MUI.onCastEF
    MUI.eF.lastCast=999999
    
    MUI.ReM=createCDIcon(115151,"big")
    MUI.ReM:SetPoint("TOP",MUI.eF,"BOTTOM",0,-1)
    MUI.ReM.onCast=MUI.onCastReM
    MUI.ReM.offCD.text2:SetTextColor(green[1],green[2],green[3])

    MUI.tFT=createCDIcon(116680,"big")
    MUI.tFT:SetPoint("RIGHT",MUI.ReM,"LEFT",-1,0)
    MUI.tFT.onCast=MUI.onCastTFT
    
    MUI.tFT.stacks=MUI.tFT.offCD:CreateFontString(nil,"OVERLAY")
    MUI.tFT.stacks:SetFont("Fonts\\FRIZQT__.ttf",MUI.bigFS,"OUTLINE")
    MUI.tFT.stacks:SetPoint("CENTER")
    MUI.tFT.stacks:SetTextColor(green[1],green[2],green[3])
    
    MUI.mT=createCDIcon(197908,"med")
    MUI.mT:SetPoint("TOPLEFT",MUI.tFT,"BOTTOMLEFT",0,-1)
    MUI.mT.onCast=MUI.onCast1

    MUI.rSK=createCDIcon(107428,"med")
    MUI.rSK:SetPoint("TOPRIGHT",MUI.eF,"BOTTOMRIGHT",0,-2-MUI.bigS)
    MUI.rSK.onCast=MUI.onCast1

    MUI.BoK={}
    MUI.BoK.onCast=MUI.onCastBoK
    port[100784]=MUI.BoK

    MUI.tP={}
    MUI.tP.onCast=MUI.onCastTP
    port[100780]=MUI.tP

    MUI.totm=createAuraIcon(116645,"med")
    MUI.totm:SetPoint("TOP",MUI.rSK,"BOTTOM",0,-1)
    MUI.totm.normal.text:SetTextColor(green[1],green[2],green[3])
    MUI.totm.normal.cd:SetReverse(true)
    MUI.totm.check=checkTOTM
    
    MUI.cB=createCDIcon(123986,"med")
    MUI.cB:SetPoint("TOP",MUI.mT,"BOTTOM",0,-1)
    MUI.cB.onCast=MUI.onCast1

    MUI.rev=createCDIcon(115310,"med")
    MUI.rev:SetPoint("TOP",MUI.mT,"BOTTOM",0,-2-MUI.medS)
    MUI.rev.onCast=MUI.onCast1

    MUI.lC=createCDIcon(116849,"med")
    MUI.lC:SetPoint("TOP",MUI.rev,"BOTTOM",0,-1)
    MUI.lC.onCast=MUI.onCast1

    MUI.dx=createCDIcon(115450,"med")
    MUI.dx:SetPoint("TOP",MUI.totm,"BOTTOM",0,-1)
    MUI.dx.onCast=MUI.onCastDetox

    MUI.rJW=createCDIcon(196725,"big")
    MUI.rJW:SetPoint("RIGHT",MUI.eF,"LEFT",-1,0)
    MUI.rJW.onCast=MUI.onCast1

    MUI.cJ=createCDIcon(198664,"big")
    MUI.cJ:SetPoint("RIGHT",MUI.eF,"LEFT",-1,0)
    MUI.cJ.onCast=MUI.onCast1

    MUI.jSS=createAuraIcon(115313,"big")
    MUI.jSS:SetPoint("RIGHT",MUI.eF,"LEFT",-1,0)
    MUI.jSS.check=MUI.jSSCheck
    MUI.jSS.onCast=onCastJSS
    MUI.jSS.checkLite=MUI.jSSCheckLite
    MUI.jSS.normal.et=10
    MUI.jSS.normal.parent=MUI.jSS
    MUI.jSS.et=10
    
    
    port[115313]=MUI.jSS
    
    MUI.jSS.channelUp=CreateFrame("Frame",nil,MUI.jSS.normal)
    MUI.jSS.channelUp:SetAllPoints()
    MUI.jSS.channelUp.text=MUI.jSS.channelUp:CreateFontString(nil,"OVERLAY")
    MUI.jSS.channelUp.text:SetFont("Fonts\\FRIZQT__.ttf",MUI.bigFS*0.8,"OUTLINE")
    MUI.jSS.channelUp.text:SetPoint("CENTER")
    MUI.jSS.channelUp:SetScript("OnUpdate",MUI.onUpdateJSSChannelUp)
    
    MUI.jSS.channelDown=CreateFrame("Frame",nil,MUI.jSS.normal)
    MUI.jSS.channelDown:SetAllPoints()
    MUI.jSS.channelDown.text=MUI.jSS.channelDown:CreateFontString(nil,"OVERLAY")
    MUI.jSS.channelDown.text:SetFont("Fonts\\FRIZQT__.ttf",MUI.bigFS*0.8,"OUTLINE")
    MUI.jSS.channelDown.text:SetTextColor(red[1],red[2],red[3])
    MUI.jSS.channelDown.text:SetPoint("CENTER")
    MUI.jSS.channelDown.text:SetText("0")

    end

    --mana bar
    do
    local function manaUpdateFunc(self)
      local m=UnitPower("player")
      local mm=UnitPowerMax("player")
      local val=m/mm*100
      self:SetValue(val)
      self.text:SetText(mf(val))
    end


    MUI.mana=CreateFrame("StatusBar","MUImana",MUI.f,"TextStatusBar")
    MUI.mana:SetPoint("TOPLEFT",MUI.ReM,"BOTTOMLEFT",1,-1)
    MUI.mana:SetHeight(125)
    MUI.mana:SetWidth(12)
    MUI.mana:SetOrientation("VERTICAL")
    MUI.mana:SetReverseFill(false)
    MUI.mana:SetMinMaxValues(0,100)
    MUI.mana:SetStatusBarTexture(0.3,0.3,0.95,1)
    MUI.mana.update=manaUpdateFunc

    local bt=MUI.mana:GetStatusBarTexture()
    bt:SetGradientAlpha("HORIZONTAL",1,1,1,1,0.4,0.4,0.4,1)


    MUI.mana.border=CreateFrame("Frame",nil,MUI.mana)
    MUI.mana.border:SetPoint("TOPRIGHT",MUI.mana,"TOPRIGHT",3,3)
    MUI.mana.border:SetPoint("BOTTOMLEFT",MUI.mana,"BOTTOMLEFT",-6,-3)
    --MUI.mana.border:SetBackdrop(manaBD) 

    MUI.mana.text=MUI.mana.border:CreateFontString(nil,"OVERLAY")
    MUI.mana.text:SetFont("Fonts\\FRIZQT__.ttf",12,"OUTLINE")
    MUI.mana.text:SetPoint("TOP",MUI.mana,"TOP",0,-2)
    MUI.mana.text:Hide() --rmove if want to show obv.

    MUI.mana.bg=MUI.mana:CreateTexture(nil,"BACKGROUND")
    MUI.mana.bg:SetPoint("TOPRIGHT",MUI.mana,"TOPRIGHT",2,2)
    MUI.mana.bg:SetPoint("BOTTOMLEFT",MUI.mana,"BOTTOMLEFT",-2,-2)
    MUI.mana.bg:SetColorTexture(0,0,0,1)

    end

    --health bar
    do
    local function healthUpdateFunc(self)
      local m=UnitHealth("player")
      local mm=UnitHealthMax("player")
      local val=m/mm*100
      self:SetValue(val)
      self.text:SetText(mf(val))
    end


    MUI.health=CreateFrame("StatusBar","MUIhealth",MUI.f,"TextStatusBar")
    MUI.health:SetPoint("TOPRIGHT",MUI.tFT,"BOTTOMRIGHT",-1,-1)
    MUI.health:SetHeight(125)
    MUI.health:SetWidth(12)
    MUI.health:SetOrientation("VERTICAL")
    MUI.health:SetReverseFill(false)
    MUI.health:SetMinMaxValues(0,100)
    MUI.health:SetStatusBarTexture(0.3,0.85,0.3,1)
    MUI.health.update=healthUpdateFunc

    local bt=MUI.health:GetStatusBarTexture()
    bt:SetGradientAlpha("HORIZONTAL",1,1,1,1,0.4,0.4,0.4,1)

    MUI.health.border=CreateFrame("Frame",nil,MUI.health)
    MUI.health.border:SetPoint("TOPRIGHT",MUI.health,"TOPRIGHT",6,3)
    MUI.health.border:SetPoint("BOTTOMLEFT",MUI.health,"BOTTOMLEFT",-3,-3)
    --MUI.health.border:SetBackdrop(healthBD) 

    MUI.health.text=MUI.health.border:CreateFontString(nil,"OVERLAY")
    MUI.health.text:SetFont("Fonts\\FRIZQT__.ttf",12,"OUTLINE")
    MUI.health.text:SetPoint("TOP",MUI.health,"TOP",0,-2)
    MUI.health.text:Hide() --rmove if want to show obv.

    MUI.health.bg=MUI.health:CreateTexture(nil,"BACKGROUND")
    MUI.health.bg:SetPoint("TOPRIGHT",MUI.health,"TOPRIGHT",2,2)
    MUI.health.bg:SetPoint("BOTTOMLEFT",MUI.health,"BOTTOMLEFT",-2,-2)
    MUI.health.bg:SetColorTexture(0,0,0,1)
    end

    --JSS stuff
    do
    
    local f=MUI.jSS
    f:RegisterEvent("PLAYER_TOTEM_UPDATE")
    local function jssOnEvent(self,event)
      if event=="UNIT_AURA" then      
        local unit=self.unit      
        if not hasJSS(unit) then       
          self.channelDown:Show()
          self.channelUp:Hide()
          self.unit=nil
          self.channeling=false
          self:UnregisterEvent("UNIT_AURA")
        end  
        
      else
        self:checkLite()
      end
    end
    f:SetScript("OnEvent",jssOnEvent)
    
    end
    
    --things to do on PLAYER_ENTERING_WORLD
    checkTalentStuff()
    fOnShow()
    checkSpecialization()
    if playerName=="Qubit" then MUI.f:SetPoint("TOPRIGHT",_eFGlobal.units,"TOPLEFT",-3,0) end
    checkCombat()
  end
end)













